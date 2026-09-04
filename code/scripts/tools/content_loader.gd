extends RefCounted

# Loads db/ content that isn't part of the VFS tree: protocols, hardware,
# components, and software bank entries. Unlike vfs_loader's instance/template
# chain, most of these are looked up directly by id/rfc field -- software
# bank entries additionally support an extends chain via vfs_loader.load_doc,
# once a given tool actually forks per lineage (none do yet).

const DBJson := preload("res://scripts/tools/db_json.gd")
const ExtendsChainLoader := preload("res://scripts/tools/extends_chain_loader.gd")

static func find_protocol_by_rfc(rfc_query: String) -> Dictionary:
	var needle := _normalize(rfc_query)
	for path in DBJson.list_json_files("protocols"):
		var doc = DBJson.read(path)
		if typeof(doc) != TYPE_DICTIONARY:
			continue
		if _normalize(str(doc.get("rfc", ""))) == needle or _normalize(str(doc.get("id", ""))).ends_with(needle):
			return doc
	return {}

static func load_hardware(id: String) -> Dictionary:
	for path in DBJson.list_json_files("hardware"):
		var doc = DBJson.read(path)
		if typeof(doc) == TYPE_DICTIONARY and doc.get("id") == id:
			return doc
	return {}

static func load_component(id: String) -> Dictionary:
	for path in DBJson.list_json_files("components"):
		var doc = DBJson.read(path)
		if typeof(doc) == TYPE_DICTIONARY and doc.get("id") == id:
			return doc
	return {}

static func load_software(tool_id: String) -> Dictionary:
	return ExtendsChainLoader.load_doc("software", "templates", tool_id)

# Derives a machine's /dev/<hostname>/ subtree from its hardware doc + which
# components are actually installed, instead of that subtree being
# hand-authored VFS content that can drift out of sync with db/hardware/ and
# db/components/. Only synthesizes devices for slots the hardware doc
# actually defines -- e.g. relay.courier-rig.class-c only has power/buffer
# slots today, no laser/transceiver slot yet, so laser.tx/laser.rx aren't
# synthesized. That's a real gap in the hardware schema, not something to
# paper over here by inventing a slot db/hardware/ doesn't define.
static func synthesize_dev_folder(hardware_state: Dictionary, hostname: String) -> Dictionary:
	if hardware_state.is_empty():
		return {}
	var hardware := load_hardware(hardware_state.get("type_ref", ""))
	if hardware.is_empty():
		return {}
	var installed: Dictionary = hardware_state.get("installed_components", {})
	var children := {}
	for slot_name in hardware.get("slots", {}).keys():
		var slot: Dictionary = hardware["slots"][slot_name]
		var file_name: String = "%s0" % slot_name if slot_name == "buffer" else slot_name
		var content: String
		if installed.has(slot_name):
			content = _render_installed_device(slot_name, installed[slot_name])
		else:
			content = _render_slot_device(slot_name, slot)
		children[file_name] = {
			"kind": "file", "perms": "crw-rw----", "owner": "root", "group": "union",
			"size": "0", "mtime": "118-09-02 14:02", "content": content
		}
	return {
		"kind": "dir", "perms": "drwxrwx---", "owner": "tech", "group": "union",
		"size": str(children.size() * 40), "mtime": "118-09-02 14:02", "children": children
	}

static func _render_installed_device(slot_name: String, install: Dictionary) -> String:
	var component := load_component(install.get("component_ref", ""))
	if component.is_empty():
		return "[%s] unknown component: %s\n" % [slot_name, install.get("component_ref", "?")]
	var degraded_str := "degraded" if install.get("degraded", false) else "nominal"
	return "[%s0] %s -- %s\nsubscription_current: %s\nduty_limit_pct_per_hour: %s rated / %s locked\n" % [
		slot_name, component.get("sku", "?"), degraded_str,
		str(install.get("subscription_current", false)).to_lower(),
		fmt_num(component.get("rated_duty_limit_pct_per_hour", "?")),
		fmt_num(component.get("locked_duty_limit_pct_per_hour", "?"))
	]

static func _render_slot_device(slot_name: String, slot: Dictionary) -> String:
	if slot_name == "power":
		return "power_class: %s\npeak_power_w: %s\nsustained_power_w: %s\nduty_limit_pct_per_hour: %s\n" % [
			slot.get("power_class", "?"), fmt_num(slot.get("peak_power_w", "?")),
			fmt_num(slot.get("sustained_power_w", "?")), fmt_num(slot.get("duty_limit_pct_per_hour", "?"))
		]
	return "[%s] slot defined, nothing installed\n" % slot_name

# JSON.parse_string returns all numbers as float (Godot 4 doesn't distinguish
# int/float in JSON) -- format whole numbers without a trailing ".0" so
# device readouts don't show "10.0" for what's meant to be a plain integer.
static func fmt_num(value) -> String:
	if typeof(value) == TYPE_FLOAT and value == floor(value):
		return str(int(value))
	return str(value)

static func _normalize(s: String) -> String:
	return s.to_lower().replace("-", "").replace(" ", "").replace("_", "")
