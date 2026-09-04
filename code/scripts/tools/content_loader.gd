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

static func _normalize(s: String) -> String:
	return s.to_lower().replace("-", "").replace(" ", "").replace("_", "")
