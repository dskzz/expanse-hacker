extends VBoxContainer

@onready var output: RichTextLabel = $Output
@onready var input: LineEdit = $Input

func _ready() -> void:
	input.text_submitted.connect(_on_submitted)
	_print_line("SolHacker console -- type 'help' for commands.")
	input.grab_focus()

func _on_submitted(text: String) -> void:
	var trimmed := text.strip_edges()
	if trimmed == "":
		input.clear()
		return
	_print_line("> " + trimmed)
	_run_command(trimmed)
	input.clear()

func _run_command(command: String) -> void:
	match command:
		"help":
			_print_line("Commands: help, clear, whoami")
		"clear":
			output.clear()
		"whoami":
			_print_line("unauthenticated // no session bound")
		_:
			_print_line("unrecognized command: " + command)

func _print_line(text: String) -> void:
	output.append_text(text + "\n")
