extends RefCounted

# Loads a VFS "instance" JSON, resolving its "extends" chain of templates via
# JSON Merge Patch (RFC 7386) and resolving content_ref against the shared
# registry. Data lives in db/vfs/ (templates/, instances/, registry/files.json)
# -- a sibling of code/, outside the Godot project, so it's readable by both
# Claude Code sessions and stays out of the engine/UI moddability boundary.

const REGISTRY_RELATIVE_PATH := "registry/files.json"

static func load_instance(instance_id: String) -> Dictionary:
	var doc := _load_doc("instances", instance_id)
	var registry := _load_registry()
	var tree: Dictionary = doc.get("tree", {})
	for child in tree.values():
		_resolve_refs(child, registry)
	return {"identity": doc.get("identity", {}), "tree": tree}

static func _load_doc(kind: String, id: String) -> Dictionary:
	var path := _data_root().path_join("%s/%s.json" % [kind, id])
	var raw = _read_json(path)
	if typeof(raw) != TYPE_DICTIONARY:
		push_error("VFSLoader: could not load %s" % path)
		return {"identity": {}, "tree": {}}
	var doc: Dictionary = raw
	var merged := {"identity": {}, "tree": {}}
	if doc.has("extends"):
		merged = _load_doc("templates", doc["extends"])
	merged["identity"] = _merge_patch(merged.get("identity", {}), doc.get("identity", {}))
	merged["tree"] = _merge_patch(merged.get("tree", {}), doc.get("tree", {}))
	return merged

static func _merge_patch(original, patch):
	if typeof(patch) != TYPE_DICTIONARY:
		return patch
	var base: Dictionary = original.duplicate(true) if typeof(original) == TYPE_DICTIONARY else {}
	for key in patch.keys():
		var patch_value = patch[key]
		if patch_value == null:
			base.erase(key)
		elif typeof(patch_value) == TYPE_DICTIONARY and base.has(key) and typeof(base[key]) == TYPE_DICTIONARY:
			base[key] = _merge_patch(base[key], patch_value)
		else:
			base[key] = patch_value
	return base

static func _resolve_refs(node: Dictionary, registry: Dictionary) -> void:
	if node.get("kind") == "file" and node.has("content_ref"):
		var ref: String = node["content_ref"]
		node["content"] = registry.get(ref, "[missing content_ref: %s]" % ref)
	if node.get("kind") == "dir":
		for child in node.get("children", {}).values():
			_resolve_refs(child, registry)

static func _load_registry() -> Dictionary:
	var raw = _read_json(_data_root().path_join(REGISTRY_RELATIVE_PATH))
	return raw if typeof(raw) == TYPE_DICTIONARY else {}

static func _read_json(path: String):
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null
	var text := file.get_as_text()
	file.close()
	return JSON.parse_string(text)

static func _data_root() -> String:
	return ProjectSettings.globalize_path("res://../db/vfs").simplify_path()
