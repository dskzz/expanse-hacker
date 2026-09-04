extends RefCounted

# Loads a VFS "instance" JSON, resolving its "extends" chain of templates via
# the shared JSON Merge Patch loader, and resolving content_ref against the
# shared registry. See reference/vfs_template_system.md.

const DBJson := preload("res://scripts/tools/db_json.gd")
const ExtendsChainLoader := preload("res://scripts/tools/extends_chain_loader.gd")

const REGISTRY_RELATIVE_PATH := "vfs/registry/files.json"

static func load_instance(instance_id: String) -> Dictionary:
	var doc := ExtendsChainLoader.load_doc("vfs", "instances", instance_id)
	var registry := _load_registry()
	var tree: Dictionary = doc.get("tree", {})
	for child in tree.values():
		_resolve_refs(child, registry)
	return doc

static func _resolve_refs(node: Dictionary, registry: Dictionary) -> void:
	if node.get("kind") == "file" and node.has("content_ref"):
		var ref: String = node["content_ref"]
		node["content"] = registry.get(ref, "[missing content_ref: %s]" % ref)
	if node.get("kind") == "dir":
		for child in node.get("children", {}).values():
			_resolve_refs(child, registry)

static func _load_registry() -> Dictionary:
	var raw = DBJson.read(REGISTRY_RELATIVE_PATH)
	return raw if typeof(raw) == TYPE_DICTIONARY else {}
