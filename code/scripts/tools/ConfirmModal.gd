extends Control

# Big confirm/cancel modal for consequential actions, per
# docs/systems/glove-safe-ui.md section 5 -- oversized tap targets,
# physically hard to fat-finger. Driven by the same Action/Observation
# shape as everything else: the UI asks, the player's tap is the answer.

signal confirmed
signal cancelled

@onready var message_label: Label = $Panel/VBox/MessageLabel
@onready var confirm_button: Button = $Panel/VBox/ButtonRow/ConfirmButton
@onready var cancel_button: Button = $Panel/VBox/ButtonRow/CancelButton

func _ready() -> void:
	confirm_button.pressed.connect(_on_confirm_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)

func setup(message: String, confirm_label: String = "CONFIRM", cancel_label: String = "ABORT", accent_color: String = "") -> void:
	message_label.text = message
	confirm_button.text = confirm_label
	cancel_button.text = cancel_label
	if accent_color != "":
		# The low-effort per-faction reskin surface (Dan, 2026-09-05): one
		# accent color from /etc/scrapper.profile (COLOR_ACCENT), not a
		# separate implementation per lineage. Status-light safety colors
		# elsewhere stay universal on purpose -- only this chrome accent is
		# meant to vary.
		var color := Color(accent_color)
		confirm_button.add_theme_color_override("font_color", color)
		message_label.add_theme_color_override("font_color", color)

func _on_confirm_pressed() -> void:
	confirmed.emit()
	queue_free()

func _on_cancel_pressed() -> void:
	cancelled.emit()
	queue_free()
