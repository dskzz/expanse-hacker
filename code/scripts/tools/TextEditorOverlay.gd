extends Control

# Shared text-editor core, per docs/systems/text-editor.md: one CodeEdit-
# backed editor, nano-shaped on every lineage (always-insert, no vi
# grammar) -- only the command name a lineage types to open it varies
# (Console.gd's _editor_name), never this behavior. Real nano keybindings
# (Ctrl-O write out, Ctrl-X exit) are the primary path per the doc's
# explicit call that these aren't a rendering artifact to discard; the
# buttons are additive, there for discoverability and for glove mode.

signal saved(text: String)
signal closed

const ConfirmModalScene := preload("res://scenes/tools/ConfirmModal.tscn")

@onready var path_label: Label = $Panel/VBox/PathLabel
@onready var text_edit: CodeEdit = $Panel/VBox/Editor
@onready var write_button: Button = $Panel/VBox/ButtonRow/WriteButton
@onready var exit_button: Button = $Panel/VBox/ButtonRow/ExitButton

var _path := ""
var _initial_content := ""
var _accent_color := ""

func _ready() -> void:
	write_button.pressed.connect(_on_write_out_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	text_edit.gui_input.connect(_on_text_edit_gui_input)
	text_edit.grab_focus()

func setup(path: String, initial_content: String, accent_color: String = "") -> void:
	_path = path
	_initial_content = initial_content
	_accent_color = accent_color
	path_label.text = path
	text_edit.text = initial_content
	if accent_color != "":
		path_label.add_theme_color_override("font_color", Color(accent_color))

func _on_text_edit_gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.ctrl_pressed:
		if event.keycode == KEY_O:
			_on_write_out_pressed()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_X:
			_on_exit_pressed()
			get_viewport().set_input_as_handled()

func _on_write_out_pressed() -> void:
	# Real nano semantics: write out does NOT close the editor.
	saved.emit(text_edit.text)
	_initial_content = text_edit.text

func _on_exit_pressed() -> void:
	if text_edit.text != _initial_content:
		_confirm_exit()
	else:
		_do_close()

func _confirm_exit() -> void:
	var modal := ConfirmModalScene.instantiate()
	get_parent().add_child(modal)
	modal.setup("Save changes to %s before exit?" % _path, "SAVE", "DISCARD", _accent_color)
	modal.confirmed.connect(func():
		saved.emit(text_edit.text)
		_do_close()
	)
	modal.cancelled.connect(func():
		_do_close()
	)

func _do_close() -> void:
	closed.emit()
	queue_free()
