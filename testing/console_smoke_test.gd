extends SceneTree

# Headless smoke test for the Console tool + the VFS/Software Bank loaders.
# Run with: godot --headless -s testing/console_smoke_test.gd --path code

const VFSLoader := preload("res://scripts/tools/vfs_loader.gd")
const ContentLoader := preload("res://scripts/tools/content_loader.gd")
const ExtendsChainLoader := preload("res://scripts/tools/extends_chain_loader.gd")

var _console: Control
var _failures := 0

func _init() -> void:
	_check_loader()

	_console = load("res://scenes/tools/Console.tscn").instantiate()
	root.add_child(_console)
	await process_frame

	_expect_contains("whoami", "tech")

	_run("cd /etc")
	_expect_output("pwd", "/etc")
	_expect_contains("cat duty-policy.conf", "ADMISSION_MODE=HANDWAVE_TX")

	_run("cd ..")
	_expect_output("pwd", "/")

	_run("cd /bin")
	_expect_output("pwd", "/usr/bin")

	_run("cd /")
	_expect_contains("cd nowhere", "no such file or directory")
	_expect_contains("cat missing.txt", "No such file or directory")
	_expect_contains("boguscmd", "command not found")

	_expect_output("ls", "bin  dev  etc  link  sbin  srv  tmp  usr  var")
	_expect_output("ls etc", "duty-policy.conf  motd  patches.log  scrapper.profile  union.trust")

	# ls coloring + aliases both come from /etc/scrapper.profile now (Belter-
	# flavored, consolidated from consolerc+aliases 2026-09-05) -- Dan's
	# "bashrc for this machine" idea, 2026-09-04. get_parsed_text() strips
	# bbcode for the checks above, so verify the loaded scheme directly.
	var color_scheme = _console.get("_color_scheme")
	if typeof(color_scheme) != TYPE_DICTIONARY or color_scheme.get("COLOR_DIR") != "#5c9cff":
		_failures += 1
		print("FAIL: /etc/scrapper.profile's COLOR_DIR didn't load into Console's color scheme: %s" % str(color_scheme))

	# /dev/<hostname>/ is synthesized from db/hardware/ + installed_components
	# at load time, not hand-authored -- per Dan's "it needs to pull from the
	# hardware doc" (2026-09-04).
	_expect_output("ls dev", "console0  relay-pallas-07")
	_expect_contains("cat dev/relay-pallas-07/buffer0", "VARS-BUF-MK2")
	_expect_contains("cat dev/relay-pallas-07/buffer0", "degraded")
	_expect_contains("cat dev/relay-pallas-07/buffer0", "rated / 4 locked")
	_expect_contains("cat dev/relay-pallas-07/power", "peak_power_w: 60")

	# Tier 2 coreutils-successors (console-commands.md), native GDScript,
	# real Software Bank entries in usr/bin.
	_run("cd /")
	_expect_contains("rg HANDWAVE /etc/duty-policy.conf", "ADMISSION_MODE=HANDWAVE_TX")
	_expect_contains("fd conf etc", "etc/duty-policy.conf")
	_expect_contains("jq slots.power.duty_limit_pct_per_hour relay.courier-rig.class-c", "10")
	_expect_contains("bat etc/duty-policy.conf", "ADMISSION_MODE=HANDWAVE_TX")
	_expect_contains("bat srv/relay/duty-reservation.state", "binary or opaque state")
	_run("cd /etc")
	_run("cd /dev")
	_run("z etc")
	_expect_output("pwd", "/etc")

	# aliases (also from /etc/scrapper.profile now) -- expanded before dispatch.
	# ll=ls -la, so this should produce the long format, not the short one.
	_run("cd /")
	_expect_contains("ll", "drwxr")

	# --help (nix-style, per Dan's ask 2026-09-05): every usr/bin tool's
	# usage/synopsis/options come straight from its own db/software/ JSON --
	# Console.gd's renderer is generic, not per-tool text.
	_expect_contains("rg --help", "Usage: rg <pattern>")
	_expect_contains("rg --help", "Recursively search file contents")
	_expect_contains("spec --help", "Options:")
	_expect_contains("spec --help", "--full")
	_expect_contains("claim -h", "union quorum")

	# Software Bank fallthrough: spec/probe/claim aren't builtins, they
	# resolve via usr/bin -> db/software/.
	_expect_contains("spec rfc2305", "RFC-2305")
	_expect_contains("spec rfc2305", "policy violation")
	_expect_contains("probe rfc2305 --node RELAY-PALLAS-07", "ADMISSION_MODE=HANDWAVE_TX")
	_expect_contains("probe rfc2305 --node RELAY-PALLAS-07", "VARS-BUF-MK2")
	_expect_contains("probe rfc2305 --node RELAY-PALLAS-07", "degraded")
	# claim shows a big confirm modal (glove-safe-ui.md section 5) instead of
	# acting immediately -- verify the modal appears and that confirming it
	# (a real button press, not just calling the effect directly) produces
	# the expected follow-up output.
	_console.get_node("Output").clear()
	_run("claim root --union-vote")
	var modal := root.get_node_or_null("ConfirmModal")
	if modal == null:
		_failures += 1
		print("FAIL: `claim root --union-vote` didn't show a confirm modal")
	else:
		modal.get_node("Panel/VBox/ButtonRow/ConfirmButton").pressed.emit()
		var claim_output := _last_output()
		if not claim_output.contains("union quorum"):
			_failures += 1
			print("FAIL: confirming claim's modal didn't produce expected output, got %s" % JSON.stringify(claim_output))

	# pin/registry (glove-safe-ui.md section 3): `<command> | pin => <name>`
	# should capture the left-hand command's plain output (not run it twice,
	# not print it directly) into Console's registry.
	_console.get_node("Output").clear()
	_run("spec rfc2305 | pin => spec.rfc2305")
	var registry = _console.get("_registry")
	if typeof(registry) != TYPE_DICTIONARY or not str(registry.get("spec.rfc2305", "")).contains("RFC-2305"):
		_failures += 1
		print("FAIL: `spec rfc2305 | pin => spec.rfc2305` didn't populate the registry, got %s" % str(registry))
	if not _last_output().contains("pinned"):
		_failures += 1
		print("FAIL: pin didn't confirm with a 'pinned N chars' message")

	# palette (glove-safe-ui.md section 2): toggles a real overlay Control,
	# populated with static entries plus whatever's in the registry.
	_run("palette")
	var palette := root.get_node_or_null("PaletteOverlay")
	if palette == null:
		_failures += 1
		print("FAIL: `palette` didn't open the quick-access overlay")
	else:
		var entries := palette.get_node("Panel/VBox/Scroll/Entries")
		var found_pin := false
		for child in entries.get_children():
			if child is Button and child.text == "spec.rfc2305":
				found_pin = true
		if not found_pin:
			_failures += 1
			print("FAIL: palette didn't show the pinned 'spec.rfc2305' slot as a button")
		_run("palette")
		if _console.get("_palette") != null:
			_failures += 1
			print("FAIL: running `palette` again didn't close it")

	# Text editor (docs/systems/text-editor.md): engine-level builtin, not
	# Software Bank -- dispatched by matching Console's loaded _editor_name
	# ("scredit" on Scrapshell) rather than a fixed command string.
	_expect_contains("scredit --help", "Usage: scredit <path>")
	_expect_contains("scredit /etc", "Is a directory")
	_expect_contains("scredit /nowhere/file.txt", "No such file or directory")
	_expect_contains("scredit dev/relay-pallas-07/buffer0", "is a device, not editable")

	# Permission enforcement (Dan, 2026-09-05): root is dr-xr-xr-x (555, no
	# write bit anywhere) -- creating a file there must now actually fail,
	# not silently succeed. /etc/motd is root:root -rw-r--r-- (no group/
	# other write) -- tech isn't the owner and isn't in the "root" group, so
	# editing it must fail too, even though tech *can* write elsewhere in
	# /etc via the group bit (drwxrwxr-x, union-writable, checked below).
	_expect_contains("scredit /newfile.txt", "Permission denied")
	_expect_contains("scredit /etc/motd", "Permission denied")

	# New file: overlay opens empty, WRITE OUT creates the file without
	# closing (real nano semantics), then EXIT with nothing further changed
	# closes directly (no unsaved-changes prompt).
	_console.get_node("Output").clear()
	_run("scredit /etc/newnote.txt")
	var editor := root.get_node_or_null("TextEditorOverlay")
	if editor == null:
		_failures += 1
		print("FAIL: `scredit /etc/newnote.txt` didn't open the text editor overlay")
	else:
		var code_edit: CodeEdit = editor.get_node("Panel/VBox/Editor")
		if code_edit.text != "":
			_failures += 1
			print("FAIL: scredit on a new path should start with an empty buffer, got %s" % JSON.stringify(code_edit.text))
		code_edit.text = "hello scredit"
		editor.get_node("Panel/VBox/ButtonRow/WriteButton").pressed.emit()
		if not _last_output().contains("bytes written"):
			_failures += 1
			print("FAIL: WRITE OUT didn't confirm with a 'bytes written' message")
		if root.get_node_or_null("TextEditorOverlay") == null:
			_failures += 1
			print("FAIL: WRITE OUT (Ctrl-O semantics) closed the editor -- it shouldn't")
		else:
			_expect_contains("cat /etc/newnote.txt", "hello scredit")
			editor.get_node("Panel/VBox/ButtonRow/ExitButton").pressed.emit()
			await process_frame # queue_free() is deferred, not synchronous
			if root.get_node_or_null("TextEditorOverlay") != null:
				_failures += 1
				print("FAIL: EXIT with no unsaved changes since the last write should close directly")
			if root.get_node_or_null("ConfirmModal") != null:
				_failures += 1
				print("FAIL: EXIT with no unsaved changes shouldn't prompt to save")

	# Existing file tech actually owns: overlay opens pre-filled with the
	# file's current content; exiting with unsaved changes prompts (reuses
	# ConfirmModal) instead of silently discarding.
	_run("scredit /etc/scrapper.profile")
	editor = root.get_node_or_null("TextEditorOverlay")
	if editor == null:
		_failures += 1
		print("FAIL: `scredit /etc/scrapper.profile` didn't open the text editor overlay")
	else:
		var code_edit: CodeEdit = editor.get_node("Panel/VBox/Editor")
		if not code_edit.text.contains("COLOR_DIR"):
			_failures += 1
			print("FAIL: scredit on an existing file should pre-fill the buffer with its content, got %s" % JSON.stringify(code_edit.text))
		code_edit.text += "\nedited."
		editor.get_node("Panel/VBox/ButtonRow/ExitButton").pressed.emit()
		var exit_modal := root.get_node_or_null("ConfirmModal")
		if exit_modal == null:
			_failures += 1
			print("FAIL: EXIT with unsaved changes should prompt to save before exit")
		else:
			exit_modal.get_node("Panel/VBox/ButtonRow/ConfirmButton").pressed.emit()
			await process_frame # queue_free() is deferred, not synchronous
			_expect_contains("cat /etc/scrapper.profile", "edited.")
			if root.get_node_or_null("TextEditorOverlay") != null:
				_failures += 1
				print("FAIL: confirming the save-before-exit prompt should close the editor")

	if _failures == 0:
		print("console_smoke_test: all checks passed")
	else:
		print("console_smoke_test: %d check(s) FAILED" % _failures)
	quit(1 if _failures > 0 else 0)

func _check_loader() -> void:
	# instance-level override wins over the role template's default
	var relay := VFSLoader.load_instance("relay-pallas-07")
	if relay["identity"].get("hostname") != "RELAY-PALLAS-07":
		_failures += 1
		print("FAIL: relay-pallas-07 hostname override didn't apply")
	var union_trust: String = relay["tree"]["etc"]["children"]["union.trust"]["content"]
	if not union_trust.contains("brahms.tech"):
		_failures += 1
		print("FAIL: relay-pallas-07 union.trust instance override didn't apply")
	# base scrapshell field (owner) inherited untouched through two layers
	if relay["tree"]["etc"]["owner"] != "root":
		_failures += 1
		print("FAIL: base scrapshell /etc owner field lost during inheritance")
	# non-tree top-level content (hardware) merges through the chain too
	if relay.get("hardware", {}).get("type_ref") != "relay.courier-rig.class-c":
		_failures += 1
		print("FAIL: relay-pallas-07 hardware block didn't load")

	# null in a child template deletes an inherited key
	var mini_direct := ExtendsChainLoader.load_doc("vfs", "templates", "miniscrapshell")
	if mini_direct["tree"]["usr"]["children"].has("lib"):
		_failures += 1
		print("FAIL: miniscrapshell's null-delete of usr/lib didn't apply")

	# cross-lineage instancing (Earthstock-descended, not Scrapshell)
	var mao := VFSLoader.load_instance("mao-quickphone")
	if mao["identity"].get("lineage_label") != "Mao-Kwikowski QuikPhone OS":
		_failures += 1
		print("FAIL: mao-quickphone identity override didn't apply")

	# Software Bank content loads and resolves by rfc field
	var protocol := ContentLoader.find_protocol_by_rfc("rfc2305")
	if protocol.get("id") != "solnet.rfc2305/duty-reservation":
		_failures += 1
		print("FAIL: ContentLoader.find_protocol_by_rfc('rfc2305') didn't resolve")
	var spec_tool := ContentLoader.load_software("spec")
	if spec_tool.get("effect", {}).get("type") != "spec_lookup":
		_failures += 1
		print("FAIL: ContentLoader.load_software('spec') didn't resolve")

func _run(command: String) -> void:
	_console.call("_run_command", command)

func _last_output() -> String:
	return _console.get_node("Output").get_parsed_text()

func _expect_output(command: String, expected: String) -> void:
	_console.get_node("Output").clear()
	_run(command)
	var actual := _last_output().strip_edges(false, true)
	if actual != expected.strip_edges(false, true):
		_failures += 1
		print("FAIL: `%s` -> expected %s, got %s" % [command, JSON.stringify(expected), JSON.stringify(actual)])

func _expect_contains(command: String, substring: String) -> void:
	_console.get_node("Output").clear()
	_run(command)
	var actual := _last_output()
	if not actual.contains(substring):
		_failures += 1
		print("FAIL: `%s` -> expected to contain %s, got %s" % [command, JSON.stringify(substring), JSON.stringify(actual)])
