extends Control
class_name ClueUIBase

# Configurations - can be changed per clue in
# the Inspector
@export var correct_code: String = ""
@export var success_message: String = "Correct!"
@export var wrong_message: String = "Wrong!"

var _input_field: LineEdit
var _feedback: Label

func _ready() -> void:
	# Ensures this UI works while the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	_input_field = get_node_or_null("Panel/VBoxContainer/HBoxContainer/LineEdit")
	_feedback = get_node_or_null("Panel/VBoxContainer/FeedbackLabel")
	if not _input_field or not _feedback:
		push_error("ClueUIBase: Missing required UI nodes. Expected LineEdit at 'Panel/VBoxContainer/HBoxContainer/LineEdit' and Label at 'Panel/VBoxContainer/FeedbackLabel'.")

	# Checks for submit/close Buttons and connects to according func
	var submit := get_node_or_null("Panel/VBoxContainer/HBoxContainer/SubmitButton")
	var close := get_node_or_null("Panel/VBoxContainer/CloseButton")
	if submit:
		submit.pressed.connect(_on_submit)
	else:
		push_warning("ClueUIBase: SubmitButton not found at 'Panel/VBoxContainer/HBoxContainer/SubmitButton'. Submit functionality will be unavailable.")
	if close:
		close.pressed.connect(close_ui)
	else:
		push_warning("ClueUIBase: CloseButton not found at 'Panel/VBoxContainer/CloseButton'. UI may not be closable via button.")

func _on_submit() -> void:
	if not _input_field or not _feedback:
		push_error("ClueUIBase: Cannot process submission because required UI nodes are missing (LineEdit or FeedbackLabel).")
		return
		
	# Checks if player wrote the correct code
	if _input_field.text.strip_edges() == correct_code:
		_feedback.text = success_message
		_feedback.modulate = Color(0.2, 0.8, 0.2)
		await get_tree().create_timer(2.0).timeout
		close_ui()
	else:
		_feedback.text = wrong_message
		_feedback.modulate = Color(0.8, 0.2, 0.2)
		_input_field.text = ""

func close_ui() -> void:
	get_tree().paused = false
	queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close_ui()
