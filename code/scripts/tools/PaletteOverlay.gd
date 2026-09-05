extends Control

# Pop-out quick-access palette, per docs/systems/glove-safe-ui.md section 2.
# Real overlay Control (not a text trick like glove_widgets.gd) populated
# from data: static pinned commands + live entries from Console's registry
# (section 3). Tapping a static entry runs it; tapping a registry entry
# inserts its pinned value into the input line instead of re-typing it.

signal command_requested(command: String)
signal value_requested(value: String)

@onready var entries_container: VBoxContainer = $Panel/VBox/Scroll/Entries

func populate(static_entries: Array, registry: Dictionary, accent_color: String = "") -> void:
	for child in entries_container.get_children():
		child.queue_free()
	if accent_color != "":
		# Same low-effort per-faction reskin surface as ConfirmModal -- one
		# accent color from /etc/scrapper.profile, not a separate palette per lineage.
		$Panel/VBox/Title.add_theme_color_override("font_color", Color(accent_color))
	for entry in static_entries:
		var btn := Button.new()
		btn.text = entry.get("label", "?")
		btn.custom_minimum_size = Vector2(0, 36)
		var command: String = entry.get("command", "")
		btn.pressed.connect(func(): command_requested.emit(command))
		entries_container.add_child(btn)
	if not registry.is_empty():
		var sep := Label.new()
		sep.text = "-- pinned --"
		entries_container.add_child(sep)
		for slot_name in registry.keys():
			var btn := Button.new()
			btn.text = slot_name
			btn.custom_minimum_size = Vector2(0, 36)
			var value: String = registry[slot_name]
			btn.pressed.connect(func(): value_requested.emit(value))
			entries_container.add_child(btn)
