extends Control

# Nodes
var input: LineEdit
var feedback: Label
var submit_button: Button
var close_button: Button
var clue_text: RichTextLabel

const CORRECT_ANSWER := "8"  # Pluto clue

func _ready():
	# Get nodes safely
	input = get_node_or_null("Panel/VBoxContainer/HBoxContainer/LineEdit")
	feedback = get_node_or_null("Panel/VBoxContainer/FeedbackLabel")
	submit_button = get_node_or_null("Panel/VBoxContainer/HBoxContainer/SubmitButton")
	close_button = get_node_or_null("Panel/VBoxContainer/CloseButton")
	clue_text = get_node_or_null("Panel/VBoxContainer/RichTextLabel")

	# Connect buttons
	if submit_button:
		submit_button.pressed.connect(_on_submit_pressed)
	if close_button:
		close_button.pressed.connect(_on_close_pressed)

func _on_submit_pressed():
	if not input or not feedback:
		print("Error: Input or feedback not found")
		return

	var answer := input.text.strip_edges()
	if answer == CORRECT_ANSWER:
		feedback.text = "Correct! The textbook confirms there are 8 planets."
		feedback.modulate = Color(0.2, 0.8, 0.2)
		await get_tree().create_timer(1.5).timeout
		_close_clue()
	else:
		feedback.text = "That's not correct. Read the textbook carefully."
		feedback.modulate = Color(0.8, 0.2, 0.2)
		input.text = ""

func _on_close_pressed():
	_close_clue()

func _close_clue():
	get_tree().paused = false
	queue_free()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_close_clue()
