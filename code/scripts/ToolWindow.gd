extends Panel

signal closed
signal focus_requested

const MIN_SIZE := Vector2(280, 180)

@onready var title_bar: Panel = $TitleBar
@onready var title_label: Label = $TitleBar/HBox/Title
@onready var close_button: Button = $TitleBar/HBox/CloseButton
@onready var content_slot: Control = $ContentSlot
@onready var resize_handle: Control = $ResizeHandle

var _dragging := false
var _drag_offset := Vector2.ZERO
var _resizing := false
var _resize_start_size := Vector2.ZERO
var _resize_start_mouse := Vector2.ZERO

func _ready() -> void:
	custom_minimum_size = MIN_SIZE
	close_button.pressed.connect(_on_close_pressed)
	title_bar.gui_input.connect(_on_title_bar_input)
	gui_input.connect(_on_panel_input)
	resize_handle.gui_input.connect(_on_resize_handle_input)

func setup(title: String, content: Control) -> void:
	title_label.text = title
	for child in content_slot.get_children():
		child.queue_free()
	content_slot.add_child(content)
	content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

func _on_close_pressed() -> void:
	closed.emit()
	queue_free()

func _on_panel_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		focus_requested.emit()

func _on_title_bar_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_dragging = true
			_drag_offset = get_global_mouse_position() - global_position
			focus_requested.emit()
		else:
			_dragging = false
	elif event is InputEventMouseMotion and _dragging:
		global_position = get_global_mouse_position() - _drag_offset

func _on_resize_handle_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_resizing = true
			_resize_start_size = size
			_resize_start_mouse = get_global_mouse_position()
			focus_requested.emit()
		else:
			_resizing = false
	elif event is InputEventMouseMotion and _resizing:
		var delta := get_global_mouse_position() - _resize_start_mouse
		size = (_resize_start_size + delta).max(MIN_SIZE)
