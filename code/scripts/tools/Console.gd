extends VBoxContainer

const VFSLoader := preload("res://scripts/tools/vfs_loader.gd")
const DEFAULT_INSTANCE := "relay-pallas-07"

@onready var output: RichTextLabel = $Output
@onready var prompt_label: Label = $InputRow/PromptLabel
@onready var input: LineEdit = $InputRow/Input

var _vfs: Dictionary = {}
var _cwd: PackedStringArray = []
var _history: Array[String] = []
var _history_index: int = -1

var _hostname := "unknown-host"
var _lineage_label := "unknown-lineage"
var _user := "tech"

func _ready() -> void:
	_load_vfs(DEFAULT_INSTANCE)
	prompt_label.text = _prompt()
	input.text_submitted.connect(_on_submitted)
	input.gui_input.connect(_on_input_gui_input)
	_print_line("%s [lag +0.4s]" % _prompt().strip_edges())
	input.grab_focus()

func _load_vfs(instance_id: String) -> void:
	var loaded := VFSLoader.load_instance(instance_id)
	var identity: Dictionary = loaded["identity"]
	_hostname = identity.get("hostname", instance_id.to_upper())
	_lineage_label = identity.get("lineage_label", "unknown-lineage")
	_user = identity.get("user", "tech")
	_vfs = {"kind": "dir", "perms": "dr-xr-xr-x", "owner": "root", "group": "root", "size": "0", "mtime": "", "children": loaded["tree"]}

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
	var args := line.split(" ", false)
	var cmd := args[0]
	args.remove_at(0)
	match cmd:
		"help":
			_print_line("Commands: help, clear, whoami, pwd, ls [-la] [path], cd [path], cat <path>")
		"clear":
			output.clear()
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
			_print_line("%s: command not found" % cmd)

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
		_print_line("  ".join(entry_names))
		return
	_print_line(_format_ls_row(node, "."))
	var children: Dictionary = node["children"]
	var names := children.keys()
	names.sort()
	for entry_name in names:
		_print_line(_format_ls_row(children[entry_name], entry_name))

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
		node["perms"], link_count, node["owner"], node["group"], node["size"], node["mtime"], display_name
	]

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
	output.append_text(node["content"])

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
	output.append_text(text + "\n")
