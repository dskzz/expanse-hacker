extends RefCounted

# Generic JSON Merge Patch (RFC 7386) extends-chain resolver, used by any db/
# content shaped as templates/ + instances/ with an "extends" field -- vfs/,
# software/, and (per db/README.md's 2026-09-04 resolution) eventually
# protocols/hardware/trust/ too, so this lives independently of vfs_loader
# rather than being vfs-specific.

const DBJson := preload("res://scripts/tools/db_json.gd")

const NON_CONTENT_KEYS := ["id", "extends"]

# base_dir e.g. "vfs" or "software"; kind e.g. "templates" or "instances".
static func load_doc(base_dir: String, kind: String, id: String) -> Dictionary:
	var raw = DBJson.read("%s/%s/%s.json" % [base_dir, kind, id])
	if typeof(raw) != TYPE_DICTIONARY:
		push_error("ExtendsChainLoader: could not load %s/%s/%s.json" % [base_dir, kind, id])
		return {}
	var doc: Dictionary = raw
	var merged := {}
	if doc.has("extends"):
		merged = load_doc(base_dir, "templates", doc["extends"])
	for key in doc.keys():
		if key in NON_CONTENT_KEYS:
			continue
		merged[key] = merge_patch(merged.get(key, {}), doc[key])
	return merged

static func merge_patch(original, patch):
	if typeof(patch) != TYPE_DICTIONARY:
		return patch
	var base: Dictionary = original.duplicate(true) if typeof(original) == TYPE_DICTIONARY else {}
	for key in patch.keys():
		var patch_value = patch[key]
		if patch_value == null:
			base.erase(key)
		elif typeof(patch_value) == TYPE_DICTIONARY and base.has(key) and typeof(base[key]) == TYPE_DICTIONARY:
			base[key] = merge_patch(base[key], patch_value)
		else:
			base[key] = patch_value
	return base
