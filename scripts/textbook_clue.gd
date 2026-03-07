extends Control

var input: LineEdit
var feedback: Label
var submit_button: Button
var close_button: Button

const CORRECT_CODE := "8"

func _ready():
	# Get nodes safely with error checking
	input = get_node_or_null("Panel/VBoxContainer/HBoxContainer/LineEdit")
	feedback = get_node_or_null("Panel/VBoxContainer/FeedbackLabel")
	submit_button = get_node_or_null("Panel/VBoxContainer/HBoxContainer/SubmitButton")
	close_button = get_node_or_null("Panel/VBoxContainer/CloseButton")
	
	# Add null checks to prevent errors
	if submit_button:
		submit_button.pressed.connect(_on_submit_pressed)
	else:
		print("Error: Submit button not found at Panel/VBoxContainer/HBoxContainer/SubmitButton")
		
	if close_button:
		close_button.pressed.connect(_on_close_pressed)
	else:
		print("Error: Close button not found at Panel/VBoxContainer/CloseButton")

func _on_submit_pressed():
	if not input or not feedback:
		print("Error: Input or feedback node not found!")
		return
		
	var ans := input.text.strip_edges()
	if ans == CORRECT_CODE:
		feedback.text = " Correct!"
		feedback.modulate = Color(0.2, 0.8, 0.2, 1)
		# Wait a moment then close
		await get_tree().create_timer(2.0).timeout
		close_ui()
	else:
		feedback.text = "Wrong!"
		feedback.modulate = Color(0.8, 0.2, 0.2, 1)
		input.text = ""

func _on_close_pressed():
	close_ui()

func close_ui():
	get_tree().paused = false
	queue_free()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close_ui()
