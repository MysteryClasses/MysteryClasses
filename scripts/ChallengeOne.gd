extends Control

var input1: LineEdit
var input2: LineEdit
var feedback: Label
var submit_button: Button
var close_button: Button

const CORRECT_CODE := ["5", "8"]

func _ready():
	input1 = get_node_or_null("Panel/VBoxContainer/HBoxContainer/LineEdit1")
	input2 = get_node_or_null("Panel/VBoxContainer/HBoxContainer/LineEdit2")
	feedback = get_node_or_null("Panel/VBoxContainer/FeedbackLabel")
	submit_button = get_node_or_null("Panel/VBoxContainer/HBoxContainer/SubmitButton")
	close_button = get_node_or_null("Panel/VBoxContainer/CloseButton")

	if submit_button:
		submit_button.pressed.connect(_on_submit_pressed)

	if close_button:
		close_button.pressed.connect(_on_close_pressed)


func _on_submit_pressed():
	if not input1 or not input2 or not feedback:
		print("Error: Missing nodes")
		return

	var ans1 := input1.text.strip_edges()
	var ans2 := input2.text.strip_edges()

	if [ans1, ans2] == CORRECT_CODE:
		feedback.text = "Correct! The code was entered successfully!"
		feedback.modulate = Color(0.2, 0.8, 0.2)

		await get_tree().create_timer(2.0).timeout
		close_ui()
	else:
		feedback.text = "Wrong! Look at the clues again."
		feedback.modulate = Color(0.8, 0.2, 0.2)

		input1.text = ""
		input2.text = ""


func _on_close_pressed():
	close_ui()


func close_ui():
	get_tree().paused = false
	queue_free()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close_ui()
