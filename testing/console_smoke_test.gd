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
	_expect_output("ls etc", "duty-policy.conf  motd  patches.log  union.trust")

	# /dev/<hostname>/ is synthesized from db/hardware/ + installed_components
	# at load time, not hand-authored -- per Dan's "it needs to pull from the
	# hardware doc" (2026-09-04).
	_expect_output("ls dev", "console0  relay-pallas-07")
	_expect_contains("cat dev/relay-pallas-07/buffer0", "VARS-BUF-MK2")
	_expect_contains("cat dev/relay-pallas-07/buffer0", "degraded")
	_expect_contains("cat dev/relay-pallas-07/buffer0", "rated / 4 locked")
	_expect_contains("cat dev/relay-pallas-07/power", "peak_power_w: 60")

	# Software Bank fallthrough: spec/probe/claim aren't builtins, they
	# resolve via usr/bin -> db/software/.
	_expect_contains("spec rfc2305", "RFC-2305")
	_expect_contains("spec rfc2305", "policy violation")
	_expect_contains("probe rfc2305 --node RELAY-PALLAS-07", "ADMISSION_MODE=HANDWAVE_TX")
	_expect_contains("probe rfc2305 --node RELAY-PALLAS-07", "VARS-BUF-MK2")
	_expect_contains("probe rfc2305 --node RELAY-PALLAS-07", "degraded")
	_expect_contains("claim root --union-vote", "union quorum")

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
