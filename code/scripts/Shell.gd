extends Control

const ToolWindowScene := preload("res://scenes/ToolWindow.tscn")
const ConsoleScene := preload("res://scenes/tools/Console.tscn")

const SAVE_PATH := "user://shell_state.json"

@onready var window_layer: Control = $WindowLayer
@onready var console_button: Button = $ToolBelt/ConsoleButton

var _open_windows: Dictionary = {}
var _next_offset := Vector2(40, 40)

func _ready() -> void:
	console_button.pressed.connect(_on_console_pressed)
	get_tree().root.close_requested.connect(_on_close_requested)
	_load_state()

func _on_console_pressed() -> void:
	if _open_windows.has("console"):
		_focus_window(_open_windows["console"])
		return
	_open_tool("console", "Console", ConsoleScene, Vector2(520, 360))

func _open_tool(tool_id: String, title: String, tool_scene: PackedScene, default_size: Vector2, pos: Vector2 = Vector2.ZERO) -> void:
	var window: Panel = ToolWindowScene.instantiate()
	window_layer.add_child(window)
	window.setup(title, tool_scene.instantiate())
	var window_pos := pos
	if window_pos == Vector2.ZERO:
		window_pos = _next_offset
		_next_offset += Vector2(30, 30)
	window.position = window_pos
	window.size = default_size
	window.closed.connect(_on_window_closed.bind(tool_id))
	window.focus_requested.connect(_focus_window.bind(window))
	_open_windows[tool_id] = window
	_focus_window(window)

func _on_window_closed(tool_id: String) -> void:
	_open_windows.erase(tool_id)

func _focus_window(window: Control) -> void:
	window_layer.move_child(window, window_layer.get_child_count() - 1)

func _on_close_requested() -> void:
	_save_state()
	get_tree().quit()

func _save_state() -> void:
	var windows_data := []
	for tool_id in _open_windows.keys():
		var w: Control = _open_windows[tool_id]
		windows_data.append({
			"tool_id": tool_id,
			"position": [w.position.x, w.position.y],
			"size": [w.size.x, w.size.y],
		})
	var data := {"windows": windows_data}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()

func _load_state() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	var text := file.get_as_text()
	file.close()
	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	for entry in parsed.get("windows", []):
		var tool_id: String = entry.get("tool_id", "")
		var pos_arr = entry.get("position", [40, 40])
		var size_arr = entry.get("size", [520, 360])
		var pos := Vector2(pos_arr[0], pos_arr[1])
		var sz := Vector2(size_arr[0], size_arr[1])
		match tool_id:
			"console":
				_open_tool("console", "Console", ConsoleScene, sz, pos)
