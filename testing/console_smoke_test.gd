extends SceneTree

# Headless smoke test for the Console tool + the VFS template/instance loader.
# Run with: godot --headless -s testing/console_smoke_test.gd --path code

const VFSLoader := preload("res://scripts/tools/vfs_loader.gd")

var _console: Control
var _failures := 0

func _init() -> void:
	_check_loader()

	_console = load("res://scenes/tools/Console.tscn").instantiate()
	root.add_child(_console)
	await process_frame

	_expect_contains("whoami", "tech")
	_run("cd /srv/relay")
	_expect_contains("cat expp.state", "probe expp")

	_run("cd /etc")
	_expect_output("pwd", "/etc")
	_expect_output("cat expp.conf", "SEQ_WRAP_VALIDATE=unset\n# unset since gen.2. changing this is considered bad luck.\n")

	_run("cd ..")
	_expect_output("pwd", "/")

	_run("cd /bin")
	_expect_output("pwd", "/usr/bin")

	_run("cd /dev/relay")
	_expect_output("pwd", "/dev/relay")

	_expect_contains("cd nowhere", "no such file or directory")
	_expect_contains("cat missing.txt", "No such file or directory")
	_expect_contains("boguscmd", "command not found")

	_run("cd /")
	_expect_output("ls", "bin  dev  etc  link  sbin  srv  tmp  usr  var")
	_expect_output("ls etc", "expp.conf  motd  patches.log  union.trust")

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

	# content_ref resolves against the shared registry
	var rfc_text: String = relay["tree"]["srv"]["children"]["relay"]["children"]["expp.rfc.txt"]["content"]
	if not rfc_text.contains("RFC-2392"):
		_failures += 1
		print("FAIL: content_ref did not resolve against the registry")

	# null in a child template deletes an inherited key
	var mini := VFSLoader.load_instance("mao-quickphone")  # extends earthcore, not mini -- separate check below
	var mini_direct := VFSLoader._load_doc("templates", "miniscrapshell")
	if mini_direct["tree"]["usr"]["children"].has("lib"):
		_failures += 1
		print("FAIL: miniscrapshell's null-delete of usr/lib didn't apply")

	# cross-lineage instancing (Earthstock-descended, not Scrapshell)
	if mini["identity"].get("lineage_label") != "Mao-Kwikowski QuikPhone OS":
		_failures += 1
		print("FAIL: mao-quickphone identity override didn't apply")

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
