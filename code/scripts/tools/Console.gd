extends VBoxContainer

const VFSLoader := preload("res://scripts/tools/vfs_loader.gd")
const ContentLoader := preload("res://scripts/tools/content_loader.gd")
const DBJson := preload("res://scripts/tools/db_json.gd")
const GloveWidgets := preload("res://scripts/tools/glove_widgets.gd")
const ConfirmModalScene := preload("res://scenes/tools/ConfirmModal.tscn")
const PaletteOverlayScene := preload("res://scenes/tools/PaletteOverlay.tscn")
const TextEditorOverlayScene := preload("res://scenes/tools/TextEditorOverlay.tscn")
const DEFAULT_INSTANCE := "relay-pallas-07"

@onready var output: RichTextLabel = $Output
@onready var prompt_label: Label = $InputRow/PromptLabel
@onready var input: LineEdit = $InputRow/Input
@onready var palette_button: Button = $InputRow/PaletteButton

var _vfs: Dictionary = {}
var _cwd: PackedStringArray = []
var _history: Array[String] = []
var _history_index: int = -1
var _registry: Dictionary = {}
var _capturing := false
var _capture_buffer: PackedStringArray = []
var _palette: Control = null
var _recent_dirs: Array[String] = []

var _hostname := "unknown-host"
var _lineage_label := "unknown-lineage"
var _user := "tech"
# Per docs/systems/text-editor.md section 3: one shared editor core/behavior
# everywhere (nano-shaped), only the command name a lineage types to open it
# varies -- same split as bash/sash/msh sharing near-identical shell
# behavior under genuinely different names. "edit" is the generic fallback
# for lineages that haven't been given a real succession story yet
# (Earthstock/Mars/Corporate, per the doc's own open question).
var _editor_name := "edit"
# Current user's group, for the owner/group/other write check below --
# empty for lineages that haven't authored one yet, which just means the
# group tier of that check never matches (falls through to "other").
var _user_group := ""
var _hardware_state: Dictionary = {}
var _color_scheme: Dictionary = {
	"COLOR_DIR": "#5c9cff", "COLOR_SYMLINK": "#00d7d7", "COLOR_DEVICE": "#d7d700", "COLOR_EXEC": "#00d700",
	# Chrome accent (modal/palette titles, buttons) -- the reskinnable part of
	# glove-safe UI per faction/lineage. Status-light colors (nominal/degraded/
	# critical, in glove_widgets.gd) deliberately stay hardcoded/universal --
	# that's a safety convention, not a faction identity, same reasoning
	# glove-safe-ui.md section 0 gives for the whole standard being unified.
	"COLOR_ACCENT": "#00d7d7"
}
var _aliases: Dictionary = {}

func _ready() -> void:
	_load_vfs(DEFAULT_INSTANCE)
	prompt_label.text = _prompt()
	input.text_submitted.connect(_on_submitted)
	input.gui_input.connect(_on_input_gui_input)
	output.meta_clicked.connect(_on_output_meta_clicked)
	palette_button.pressed.connect(_toggle_palette)
	_print_line("%s [lag +0.4s]" % _prompt().strip_edges())
	input.grab_focus()

func _on_output_meta_clicked(meta) -> void:
	# Fires for glove_widgets.button()'s [url=<command>] tags -- a tap runs
	# the command exactly as if it had been typed and submitted, per
	# glove-safe-ui.md section 1.
	var command := str(meta)
	_print_line(_prompt() + command)
	_run_command(command)
	_reclaim_focus()

func _load_vfs(instance_id: String) -> void:
	var loaded := VFSLoader.load_instance(instance_id)
	var identity: Dictionary = loaded["identity"]
	_hostname = identity.get("hostname", instance_id.to_upper())
	_lineage_label = identity.get("lineage_label", "unknown-lineage")
	_user = identity.get("user", "tech")
	_editor_name = identity.get("editor_name", "edit")
	_user_group = identity.get("group", "")
	_hardware_state = loaded.get("hardware", {})
	var tree: Dictionary = loaded["tree"]
	var synthesized_dev := ContentLoader.synthesize_dev_folder(_hardware_state, _hostname.to_lower())
	if not synthesized_dev.is_empty() and tree.has("dev") and tree["dev"].has("children"):
		tree["dev"]["children"][_hostname.to_lower()] = synthesized_dev
	_vfs = {"kind": "dir", "perms": "dr-xr-xr-x", "owner": "root", "group": "root", "size": "0", "mtime": "", "children": tree}
	_load_profile()

func _load_profile() -> void:
	# Reads /etc/scrapper.profile as real content instead of hardcoded values --
	# this is what a future in-game text editor would let a player customize
	# live, same "bashrc for this machine" idea as any other dotfile. One
	# combined file (colors + aliases) rather than splitting a bashrc-
	# equivalent from a profile-equivalent the way real Unix does -- Scrapshell
	# never had the coordination to keep those cleanly separate either.
	# COLOR_* keys go to the color scheme, everything else is an alias.
	var conf_node = _lookup(PackedStringArray(["etc", "scrapper.profile"]))
	if conf_node == null or typeof(conf_node) != TYPE_DICTIONARY or not conf_node.has("content"):
		return
	for line in String(conf_node["content"]).split("\n"):
		var eq := line.find("=")
		if eq <= 0:
			continue
		var key := line.substr(0, eq)
		var value := line.substr(eq + 1)
		if key.begins_with("COLOR_"):
			_color_scheme[key] = value
		else:
			_aliases[key] = value

func _expand_alias(line: String) -> String:
	var space := line.find(" ")
	var first_word := line if space == -1 else line.substr(0, space)
	if not _aliases.has(first_word):
		return line
	var rest := "" if space == -1 else line.substr(space)
	return _aliases[first_word] + rest

func _prompt() -> String:
	return "%s@%s (%s) $ " % [_user, _hostname, _lineage_label]

func _on_submitted(text: String) -> void:
	call_deferred("_process_submission", text.strip_edges())

func _process_submission(trimmed: String) -> void:
	input.clear()
	_reclaim_focus()
	if trimmed != "":
		if _history.is_empty() or _history[_history.size() - 1] != trimmed:
			_history.append(trimmed)
		_history_index = -1
		_print_line(_prompt() + trimmed)
		_run_command(trimmed)
	_reclaim_focus()

func _reclaim_focus() -> void:
	# Control.grab_focus() alone doesn't reliably restore real keyboard input
	# after a LineEdit submission on this setup -- manual clicking always
	# worked, programmatic focus calls didn't, so we synthesize an actual
	# click on the input field to get whatever side effect a real click has
	# that grab_focus() doesn't. Confirmed necessary 2026-09-04.
	var window := get_window()
	if window:
		window.grab_focus()
	_simulate_click(input)
	input.grab_focus()

func _simulate_click(control: Control) -> void:
	var pos: Vector2 = control.get_global_rect().get_center()
	var press := InputEventMouseButton.new()
	press.button_index = MOUSE_BUTTON_LEFT
	press.pressed = true
	press.position = pos
	press.global_position = pos
	var release := InputEventMouseButton.new()
	release.button_index = MOUSE_BUTTON_LEFT
	release.pressed = false
	release.position = pos
	release.global_position = pos
	var viewport := control.get_viewport()
	viewport.push_input(press)
	viewport.push_input(release)

func _on_input_gui_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed):
		return
	if event.keycode == KEY_UP:
		_history_step(-1)
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_DOWN:
		_history_step(1)
		get_viewport().set_input_as_handled()

func _history_step(delta: int) -> void:
	if _history.is_empty():
		return
	if _history_index == -1:
		_history_index = _history.size()
	_history_index = clampi(_history_index + delta, 0, _history.size())
	input.text = "" if _history_index == _history.size() else _history[_history_index]
	input.caret_column = input.text.length()

func _run_command(line: String) -> void:
	line = _expand_alias(line)
	if line.contains("|"):
		_run_piped_command(line)
		return
	var args := line.split(" ", false)
	var cmd := args[0]
	args.remove_at(0)
	match cmd:
		"help":
			_print_line("Commands: help, clear, palette, whoami, pwd, ls [-la] [path], cd [path], cat <path>, %s <path> (text editor)" % _editor_name)
			_print_line("usr/bin tools: ls /usr/bin to see what this box ships; run any of them with --help for details.")
		"clear":
			output.clear()
		"palette":
			_toggle_palette()
		"whoami":
			_print_line(_user)
		"pwd":
			_print_line(_path_string(_cwd))
		"cd":
			_cmd_cd(args[0] if args.size() > 0 else "/")
		"ls":
			_cmd_ls(args)
		"cat":
			_cmd_cat(args)
		_:
			if cmd == _editor_name:
				_cmd_edit(args)
			elif not _try_software_bank(cmd, args):
				_print_line("%s: command not found" % cmd)

func _try_software_bank(cmd: String, args: PackedStringArray) -> bool:
	# usr/bin fallthrough per docs/systems/console-commands.md: unknown
	# builtin -> check usr/bin (PATH-style, absolute regardless of cwd) for a
	# Software Bank entry -> run its effect. This is the mechanism that makes
	# "filling up bin/" a content task (db/software/) instead of a code task.
	var node = _lookup(PackedStringArray(["usr", "bin", cmd]))
	if node == null or typeof(node) != TYPE_DICTIONARY or not node.has("software_ref"):
		return false
	var tool := ContentLoader.load_software(node["software_ref"])
	if tool.is_empty():
		_print_line("%s: software bank entry missing" % cmd)
		return true
	if args.has("--help") or args.has("-h"):
		_print_tool_help(cmd, tool)
		return true
	_run_software_effect(tool, args)
	return true

func _print_tool_help(cmd: String, tool: Dictionary) -> void:
	# Standard nix --help formatting (Usage / synopsis / Options), driven
	# entirely by each tool's JSON (usage/synopsis/options fields) -- new
	# Software Bank entries get real --help for free, same "data, not code"
	# pattern as the tools themselves.
	var usage: String = tool.get("usage", tool.get("help", cmd))
	_print_line("Usage: %s" % usage)
	var synopsis: String = tool.get("synopsis", "")
	if synopsis != "":
		_print_line("")
		_print_line(synopsis)
	var options: Array = tool.get("options", [])
	if not options.is_empty():
		_print_line("")
		_print_line("Options:")
		for opt in options:
			_print_line("  %-22s %s" % [opt.get("flag", "?"), opt.get("desc", "")])

func _run_software_effect(tool: Dictionary, args: PackedStringArray) -> void:
	var effect: Dictionary = tool.get("effect", {})
	match effect.get("type", ""):
		"spec_lookup":
			_effect_spec_lookup(args)
		"probe_lookup":
			_effect_probe_lookup(args)
		"root_claim":
			_effect_root_claim(tool)
		"pin_usage":
			_print_line(tool.get("help", "usage: <command> | pin => <slot-name>"))
		"grep_search":
			_effect_grep_search(args)
		"find_search":
			_effect_find_search(args)
		"json_query":
			_effect_json_query(args)
		"bat_view":
			_effect_bat_view(args)
		"zoxide_jump":
			_effect_zoxide_jump(args)
		_:
			_print_line("%s: no handler for effect '%s'" % [tool.get("id", "?"), effect.get("type", "?")])

func _effect_spec_lookup(args: PackedStringArray) -> void:
	if args.is_empty():
		_print_line("usage: spec <protocol> [--full]")
		return
	var protocol := ContentLoader.find_protocol_by_rfc(args[0])
	if protocol.is_empty():
		_print_line("spec: unknown protocol '%s'" % args[0])
		return
	var excerpt: Dictionary = protocol.get("spec_excerpt", {})
	if excerpt.is_empty():
		_print_line("spec: no curated excerpt for %s yet" % protocol.get("rfc", args[0]))
		return
	_print_line(excerpt.get("citation", ""))
	_print_line("  " + excerpt.get("section", ""))
	_print_line("    " + excerpt.get("quote", ""))
	if args.has("--full"):
		var text = DBJson.read_text(excerpt.get("vault_source", ""))
		if text == null:
			_print_line("spec: --full source not found")
		else:
			_print_line("")
			_print_line(text)
	else:
		_print_bbcode("  " + GloveWidgets.button("(read full text)", "spec %s --full" % args[0]))

func _effect_probe_lookup(args: PackedStringArray) -> void:
	if args.is_empty():
		_print_line("usage: probe <protocol> --node <target>")
		return
	var protocol := ContentLoader.find_protocol_by_rfc(args[0])
	if protocol.is_empty():
		_print_line("probe: unknown protocol '%s'" % args[0])
		return
	var target := _hostname
	var node_flag := args.find("--node")
	if node_flag != -1 and node_flag + 1 < args.size():
		target = args[node_flag + 1]

	var admission_mode := "unknown"
	var policy_node = _lookup(PackedStringArray(["etc", "duty-policy.conf"]))
	if policy_node != null and typeof(policy_node) == TYPE_DICTIONARY and policy_node.has("content"):
		for line in String(policy_node["content"]).split("\n"):
			if line.begins_with("ADMISSION_MODE="):
				admission_mode = line.trim_prefix("ADMISSION_MODE=")

	_print_line("%s: %s, ADMISSION_MODE=%s" % [target, protocol.get("id", "?"), admission_mode])
	_print_line("  (local override, see /etc/duty-policy.conf)")

	var hardware := ContentLoader.load_hardware(_hardware_state.get("type_ref", ""))
	var buffer_state: Dictionary = _hardware_state.get("installed_components", {}).get("buffer", {})
	var component := ContentLoader.load_component(buffer_state.get("component_ref", ""))
	if not hardware.is_empty() and not component.is_empty():
		var rated = hardware.get("slots", {}).get("power", {}).get("duty_limit_pct_per_hour", "?")
		var locked = component.get("locked_duty_limit_pct_per_hour", "?")
		var is_degraded: bool = buffer_state.get("degraded", false)
		var degraded_str := "degraded" if is_degraded else "nominal"
		var sub_str := str(buffer_state.get("subscription_current", false)).to_lower()
		_print_line("  buffer hardware: %s, %s (subscription_current: %s, duty_limit_pct_per_hour: %s -- rated, not the VARS-locked %s)" % [
			component.get("sku", "?"), degraded_str, sub_str, ContentLoader.fmt_num(rated), ContentLoader.fmt_num(locked)
		])
		# Glove-safe annotation layered on top of the text above, per
		# glove-safe-ui.md section 1 -- never the only rendering.
		var rated_num := float(str(rated)) if str(rated).is_valid_float() else 0.0
		var light := GloveWidgets.status_light("degraded" if is_degraded else "nominal")
		var bar := GloveWidgets.gauge(rated_num, 100.0, 10, _color_scheme.get("COLOR_EXEC", ""))
		_print_bbcode("  %s duty [%s] %s%%" % [light, bar, ContentLoader.fmt_num(rated)])

func _effect_root_claim(tool: Dictionary) -> void:
	var required = tool.get("effect", {}).get("quorum_required", 3)
	# Big confirm/cancel per glove-safe-ui.md section 5 -- claiming root is
	# exactly the kind of consequential action that doc calls out by name.
	var modal := ConfirmModalScene.instantiate()
	get_parent().add_child(modal)
	modal.setup("CLAIM ROOT?\nvia union quorum -- need %s seconds, you have 1 (yours)" % str(required), "CLAIM", "ABORT", _color_scheme.get("COLOR_ACCENT", ""))
	modal.confirmed.connect(func():
		_print_line("root claim submitted -- awaiting union quorum (need %s, have 1 -- yours)" % str(required))
		_print_line("no seconds received yet.")
		_reclaim_focus()
	)
	modal.cancelled.connect(func():
		_print_line("claim aborted.")
		_reclaim_focus()
	)

func _effect_grep_search(args: PackedStringArray) -> void:
	if args.is_empty():
		_print_line("usage: rg <pattern> [path]")
		return
	var pattern := args[0]
	var start_path := args[1] if args.size() > 1 else "."
	var regex := RegEx.new()
	if regex.compile(pattern) != OK:
		_print_line("rg: invalid pattern '%s'" % pattern)
		return
	var segments := _resolve_path(_cwd, start_path)
	var node = _lookup(segments)
	if node == null:
		_print_line("rg: cannot access '%s': No such file or directory" % start_path)
		return
	var match_count := _grep_recursive(node, segments, regex, 0)
	if match_count == 0:
		_print_line("rg: no matches")

func _grep_recursive(node: Dictionary, path_segments: PackedStringArray, regex: RegEx, count: int) -> int:
	if node["kind"] == "dir":
		for child_name in node["children"].keys():
			var child_segments := path_segments.duplicate()
			child_segments.append(child_name)
			count = _grep_recursive(node["children"][child_name], child_segments, regex, count)
	elif node["kind"] == "file" and node.has("content"):
		var line_num := 0
		for line in String(node["content"]).split("\n"):
			line_num += 1
			if regex.search(line) != null:
				count += 1
				_print_line("%s:%d: %s" % [_path_string(path_segments), line_num, line])
	return count

func _effect_find_search(args: PackedStringArray) -> void:
	if args.is_empty():
		_print_line("usage: fd <pattern> [path]")
		return
	var pattern := args[0]
	var start_path := args[1] if args.size() > 1 else "."
	var segments := _resolve_path(_cwd, start_path)
	var node = _lookup(segments)
	if node == null:
		_print_line("fd: cannot access '%s': No such file or directory" % start_path)
		return
	var results: Array = []
	_find_recursive(node, segments, pattern, results)
	if results.is_empty():
		_print_line("fd: no matches")
	for r in results:
		_print_line(r)

func _find_recursive(node: Dictionary, path_segments: PackedStringArray, pattern: String, results: Array) -> void:
	if node["kind"] != "dir":
		return
	for child_name in node["children"].keys():
		var child_segments := path_segments.duplicate()
		child_segments.append(child_name)
		if child_name.contains(pattern):
			results.append(_path_string(child_segments))
		_find_recursive(node["children"][child_name], child_segments, pattern, results)

func _effect_json_query(args: PackedStringArray) -> void:
	if args.size() < 2:
		_print_line("usage: jq <.dotted.path> <rfc-or-hardware-id>")
		return
	var path := args[0]
	var target := args[1]
	var doc := ContentLoader.find_protocol_by_rfc(target)
	if doc.is_empty():
		doc = ContentLoader.load_hardware(target)
	if doc.is_empty():
		_print_line("jq: unknown target '%s'" % target)
		return
	var value = _jq_walk(doc, path)
	if value == null:
		_print_line("jq: path '%s' not found" % path)
	elif typeof(value) == TYPE_DICTIONARY or typeof(value) == TYPE_ARRAY:
		_print_line(JSON.stringify(value, "  "))
	else:
		_print_line(str(value))

func _jq_walk(doc: Dictionary, path: String):
	var current = doc
	var clean := path.lstrip(".")
	if clean == "":
		return current
	for part in clean.split("."):
		if typeof(current) != TYPE_DICTIONARY or not current.has(part):
			return null
		current = current[part]
	return current

func _effect_bat_view(args: PackedStringArray) -> void:
	if args.is_empty():
		_print_line("usage: bat <path>")
		return
	var path := args[0]
	var segments := _resolve_path(_cwd, path)
	var node = _lookup(segments)
	if node == null:
		_print_line("bat: %s: No such file or directory" % path)
		return
	if node["kind"] == "symlink":
		segments = _resolve_path(segments.slice(0, segments.size() - 1), node["target"])
		node = _lookup(segments)
		if node == null:
			_print_line("bat: %s: No such file or directory" % path)
			return
	if node["kind"] == "dir":
		_print_line("bat: %s: Is a directory" % path)
		return
	var content: String = node.get("content", "")
	_print_bbcode("[color=%s]--- %s (%s) ---[/color]" % [_color_scheme.get("COLOR_EXEC", ""), path, node.get("perms", "?")])
	# RFC-2304 section 4's "surface uncertainty, don't hide it" doctrine,
	# per console-commands.md's bat entry: flag opaque/binary content
	# explicitly instead of dumping it garbled.
	if content.begins_with("[binary") or content.contains("state blob"):
		_print_line("<binary or opaque state, %s bytes -- use `probe` for a structured read instead>" % node.get("size", "?"))
		return
	var line_num := 0
	for line in content.split("\n"):
		line_num += 1
		_print_line("%3d | %s" % [line_num, line])

func _effect_zoxide_jump(args: PackedStringArray) -> void:
	if args.is_empty():
		_print_line("usage: z <fragment>")
		return
	var fragment := args[0]
	for i in range(_recent_dirs.size() - 1, -1, -1):
		if _recent_dirs[i].contains(fragment):
			_cmd_cd(_recent_dirs[i])
			return
	_print_line("z: no visited directory matches '%s'" % fragment)

func _toggle_palette() -> void:
	if _palette != null:
		_palette.queue_free()
		_palette = null
		return
	_palette = PaletteOverlayScene.instantiate()
	get_parent().add_child(_palette)
	var static_entries := [
		{"label": "spec rfc2305", "command": "spec rfc2305"},
		{"label": "probe rfc2305", "command": "probe rfc2305 --node %s" % _hostname},
		{"label": "ls /usr/bin", "command": "ls /usr/bin"},
		{"label": "claim root", "command": "claim root --union-vote"},
	]
	_palette.populate(static_entries, _registry, _color_scheme.get("COLOR_ACCENT", ""))
	_palette.command_requested.connect(_on_palette_command)
	_palette.value_requested.connect(_on_palette_value)

func _on_palette_command(command: String) -> void:
	_toggle_palette()
	_print_line(_prompt() + command)
	_run_command(command)
	_reclaim_focus()

func _on_palette_value(value: String) -> void:
	_toggle_palette()
	input.text += value
	input.caret_column = input.text.length()
	_reclaim_focus()

func _cmd_cd(path: String) -> void:
	var segments := _resolve_path(_cwd, path)
	var node = _lookup(segments)
	if node == null:
		_print_line("cd: no such file or directory: %s" % path)
		return
	if node["kind"] == "symlink":
		segments = _resolve_path(segments.slice(0, segments.size() - 1), node["target"])
		node = _lookup(segments)
		if node == null:
			_print_line("cd: no such file or directory: %s" % path)
			return
	if node["kind"] != "dir":
		_print_line("cd: not a directory: %s" % path)
		return
	_cwd = segments
	prompt_label.text = _prompt()
	var visited := _path_string(_cwd)
	_recent_dirs.erase(visited)
	_recent_dirs.append(visited)

func _cmd_ls(args: PackedStringArray) -> void:
	var long_format := false
	var target_arg := ""
	for a in args:
		if a.begins_with("-"):
			if a.contains("l"):
				long_format = true
		else:
			target_arg = a
	var segments := _resolve_path(_cwd, target_arg) if target_arg != "" else _cwd
	var node = _lookup(segments)
	if node == null:
		_print_line("ls: cannot access '%s': No such file or directory" % target_arg)
		return
	if node["kind"] == "symlink":
		segments = _resolve_path(segments.slice(0, segments.size() - 1), node["target"])
		node = _lookup(segments)
	if node["kind"] != "dir":
		_print_line(target_arg)
		return
	if not long_format:
		var entry_names = node["children"].keys()
		entry_names.sort()
		var colored: Array = []
		for name in entry_names:
			colored.append(_colorize_name(node["children"][name], name))
		_print_bbcode("  ".join(colored))
		return
	_print_bbcode(_format_ls_row(node, "."))
	var children: Dictionary = node["children"]
	var names := children.keys()
	names.sort()
	for entry_name in names:
		_print_bbcode(_format_ls_row(children[entry_name], entry_name))

func _format_ls_row(node: Dictionary, entry_name: String) -> String:
	var link_count := 1
	if node["kind"] == "dir":
		link_count = 2
		for child in node["children"].values():
			if child["kind"] == "dir":
				link_count += 1
	var display_name := entry_name
	if node["kind"] == "symlink":
		display_name = "%s -> %s" % [entry_name, node["target"]]
	return "%-11s %2d %-6s %-6s %6s  %s  %s" % [
		node.get("perms", "?"), link_count, node.get("owner", "?"), node.get("group", "?"),
		node.get("size", "?"), node.get("mtime", "?"), _colorize_name(node, display_name)
	]

# Real-ls-style coloring: dirs blue, symlinks cyan, device files yellow,
# executables green, plain files uncolored. Names/content are escaped
# elsewhere (_print_line/_escape_bbcode) precisely so this is the one place
# allowed to emit real [color] tags without them getting neutralized.
func _colorize_name(node: Dictionary, display_name: String) -> String:
	var color := _color_for_entry(node)
	if color == "":
		return display_name
	return "[color=%s]%s[/color]" % [color, display_name]

func _color_for_entry(node: Dictionary) -> String:
	var kind: String = node.get("kind", "")
	var perms: String = node.get("perms", "")
	if kind == "symlink":
		return _color_scheme["COLOR_SYMLINK"]
	if kind == "dir":
		return _color_scheme["COLOR_DIR"]
	if perms.begins_with("c") or perms.begins_with("b"):
		return _color_scheme["COLOR_DEVICE"]
	if perms.length() >= 10 and (perms[3] == "x" or perms[6] == "x" or perms[9] == "x"):
		return _color_scheme["COLOR_EXEC"]
	return ""

func _can_write(node: Dictionary) -> bool:
	# Real unix-style owner/group/other write check -- enforced now for
	# scredit, the only thing that actually writes to the VFS, after Dan
	# hit root's own perms (dr-xr-xr-x, 555 -- no write bit anywhere)
	# unexpectedly succeeding. Standard precedence: owner bit if you own
	# the node, else group bit if your group matches, else the other/
	# "global" bit. Group membership is one flat identity.group field, not
	# a real multi-group model -- there's exactly one player-controlled
	# user in this game, so one group is enough to make /etc's deliberately
	# group-writable perms (drwxrwxr-x, union collaboration) mean something
	# real instead of being decorative.
	var perms: String = node.get("perms", "")
	if perms.length() < 10:
		return false
	if node.get("owner", "") == _user:
		return perms[2] == "w"
	if _user_group != "" and node.get("group", "") == _user_group:
		return perms[5] == "w"
	return perms[8] == "w"

func _cmd_cat(args: PackedStringArray) -> void:
	if args.is_empty():
		_print_line("usage: cat <path>")
		return
	var path := args[0]
	var segments := _resolve_path(_cwd, path)
	var node = _lookup(segments)
	if node == null:
		_print_line("cat: %s: No such file or directory" % path)
		return
	if node["kind"] == "symlink":
		segments = _resolve_path(segments.slice(0, segments.size() - 1), node["target"])
		node = _lookup(segments)
		if node == null:
			_print_line("cat: %s: No such file or directory" % path)
			return
	if node["kind"] == "dir":
		_print_line("cat: %s: Is a directory" % path)
		return
	output.append_text(_escape_bbcode(node["content"]))

func _cmd_edit(args: PackedStringArray) -> void:
	# Engine-level builtin, not Software Bank content, per
	# docs/systems/text-editor.md's open question ("leaning toward" engine
	# UI infra since every lineage needs *an* editor, even though the
	# command name/flavor differs) -- dispatched above by matching
	# _editor_name rather than a fixed string, so the JSON identity field is
	# the only thing that varies per lineage.
	if args.has("--help") or args.has("-h"):
		_print_line("Usage: %s <path>" % _editor_name)
		_print_line("")
		_print_line("Open path in the text editor (creates it if missing). Nano-shaped: always-insert, no modal states.")
		_print_line("")
		_print_line("Options:")
		_print_line("  Ctrl-O                 Write out (save) without closing")
		_print_line("  Ctrl-X                 Exit (prompts to save if there are unsaved changes)")
		return
	if args.is_empty():
		_print_line("usage: %s <path>" % _editor_name)
		return
	var path := args[0]
	var segments := _resolve_path(_cwd, path)
	var node = _lookup(segments)
	if node != null and node["kind"] == "symlink":
		segments = _resolve_path(segments.slice(0, segments.size() - 1), node["target"])
		node = _lookup(segments)
	if node == null:
		var parent_node = _lookup(segments.slice(0, segments.size() - 1))
		if parent_node == null or typeof(parent_node) != TYPE_DICTIONARY or parent_node.get("kind", "") != "dir":
			_print_line("%s: %s: No such file or directory" % [_editor_name, path])
			return
		if not _can_write(parent_node):
			_print_line("%s: %s: Permission denied" % [_editor_name, path])
			return
	elif node["kind"] == "dir":
		_print_line("%s: %s: Is a directory" % [_editor_name, path])
		return
	elif node["perms"].begins_with("c") or node["perms"].begins_with("b"):
		_print_line("%s: %s: is a device, not editable" % [_editor_name, path])
		return
	elif not _can_write(node):
		_print_line("%s: %s: Permission denied" % [_editor_name, path])
		return
	var initial_content := "" if node == null else String(node.get("content", ""))
	var overlay := TextEditorOverlayScene.instantiate()
	get_parent().add_child(overlay)
	overlay.setup(path, initial_content, _color_scheme.get("COLOR_ACCENT", ""))
	overlay.saved.connect(func(new_text: String):
		# Re-lookup fresh each time rather than closing over `node`/`creating`
		# -- handles Ctrl-O writing out more than once in a session (first
		# write creates the file, later writes update the now-existing node)
		# without relying on GDScript lambda capture semantics for mutation.
		var existing = _lookup(segments)
		if existing == null:
			var parent_node = _lookup(segments.slice(0, segments.size() - 1))
			parent_node["children"][segments[segments.size() - 1]] = {
				"kind": "file", "perms": "-rw-r--r--", "owner": _user, "group": _user,
				"size": str(new_text.length()), "mtime": "(edited this session)", "content": new_text
			}
		else:
			existing["content"] = new_text
			existing["size"] = str(new_text.length())
		_print_line("%s: %d bytes written" % [path, new_text.length()])
	)
	overlay.closed.connect(func():
		_reclaim_focus()
	)

func _resolve_path(base: PackedStringArray, path: String) -> PackedStringArray:
	var segments := PackedStringArray() if path.begins_with("/") else base.duplicate()
	for part in path.split("/", false):
		if part == ".":
			continue
		elif part == "..":
			if segments.size() > 0:
				segments.remove_at(segments.size() - 1)
		else:
			segments.append(part)
	return segments

func _lookup(segments: PackedStringArray):
	var node: Dictionary = _vfs
	for i in range(segments.size()):
		if node["kind"] != "dir":
			return null
		var children: Dictionary = node["children"]
		var segment_name := segments[i]
		if not children.has(segment_name):
			return null
		node = children[segment_name]
		if node["kind"] == "symlink" and i < segments.size() - 1:
			var target_segments := _resolve_path(segments.slice(0, i), node["target"])
			var resolved = _lookup(target_segments)
			if resolved == null:
				return null
			node = resolved
	return node

func _path_string(segments: PackedStringArray) -> String:
	return "/" + "/".join(segments)

func _print_line(text: String) -> void:
	# Escaped by default -- most content (flavor text, error messages, cat'd
	# files) has never had to worry about literal "[" "]" before bbcode_enabled
	# was turned on for `ls` coloring. Use _print_bbcode for lines that
	# deliberately carry real formatting tags (e.g. _format_ls_row's output).
	# When capturing (a `| pin => name` pipeline, see _run_piped_command), the
	# plain un-escaped text is what actually gets stored under the slot name.
	if _capturing:
		_capture_buffer.append(text)
		return
	output.append_text(_escape_bbcode(text) + "\n")

func _print_bbcode(text: String) -> void:
	if _capturing:
		_capture_buffer.append(text)
		return
	output.append_text(text + "\n")

func _escape_bbcode(text: String) -> String:
	return text.replace("[", "[lb]").replace("]", "[rb]")

func _run_piped_command(line: String) -> void:
	# Only a single `<command> | pin => <name>` stage is supported for now --
	# per glove-safe-ui.md section 3, pin is snapshot-only (captures the
	# left-hand command's plain-text output at pin time), not a live
	# subscription. Arbitrary multi-stage pipelines aren't a v1 requirement.
	var parts := line.split("|")
	if parts.size() != 2:
		_print_line("pipelines only support one stage right now: <command> | pin => <name>")
		return
	var left := parts[0].strip_edges()
	var right_args := parts[1].strip_edges().split(" ", false)
	if right_args.is_empty() or right_args[0] != "pin":
		_print_line("only `<command> | pin => <name>` is supported right now")
		return
	var name := ""
	if right_args.size() >= 3 and right_args[1] == "=>":
		name = right_args[2]
	elif right_args.size() >= 2:
		name = right_args[1]
	if name == "":
		_print_line("usage: <command> | pin => <slot-name>")
		return
	var captured := _run_command_capturing(left)
	_registry[name] = captured
	_print_line("pinned %d chars to %s" % [captured.length(), name])
	_print_bbcode("  " + GloveWidgets.button("(open palette)", "palette"))

func _run_command_capturing(line: String) -> String:
	var was_capturing := _capturing
	var saved_buffer := _capture_buffer
	_capturing = true
	_capture_buffer = []
	_run_command(line)
	var result := "\n".join(_capture_buffer)
	_capturing = was_capturing
	_capture_buffer = saved_buffer
	return result
