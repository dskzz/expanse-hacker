extends RefCounted

# Shared helper for reading db/ content as plain JSON, via an absolute OS path
# rather than res:// -- db/ is a deliberate sibling of code/, outside Godot's
# project sandbox, so both Claude Code sessions and modders can edit it
# without touching the engine/UI project. See reference/vfs_template_system.md.

static func data_root() -> String:
	return ProjectSettings.globalize_path("res://../db").simplify_path()

static func read(relative_path: String):
	var file := FileAccess.open(data_root().path_join(relative_path), FileAccess.READ)
	if file == null:
		return null
	var text := file.get_as_text()
	file.close()
	return JSON.parse_string(text)

static func repo_root() -> String:
	return ProjectSettings.globalize_path("res://..").simplify_path()

# For plain (non-JSON) text files relative to the repo root, e.g. vault RFCs
# under docs/vault/ -- used by `spec --full`.
static func read_text(relative_path_from_repo_root: String):
	var file := FileAccess.open(repo_root().path_join(relative_path_from_repo_root), FileAccess.READ)
	if file == null:
		return null
	var text := file.get_as_text()
	file.close()
	return text

static func list_json_files(relative_dir: String) -> PackedStringArray:
	var result := PackedStringArray()
	var dir := DirAccess.open(data_root().path_join(relative_dir))
	if dir == null:
		return result
	dir.list_dir_begin()
	var name := dir.get_next()
	while name != "":
		if not dir.current_is_dir() and name.ends_with(".json"):
			result.append(relative_dir.path_join(name))
		name = dir.get_next()
	dir.list_dir_end()
	return result
