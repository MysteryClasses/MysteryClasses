extends ClueUIBase

# Correct answers for multiple input fields, set in Inspector
@export var correct_codes: Array[String] = []

var _input_field_2: LineEdit

func _ready() -> void:
	# Call ready-func of base script
	super._ready()
	# Override: searches for LineEdit1 and LineEdit2
	_input_field = get_node_or_null("Panel/VBoxContainer/HBoxContainer/LineEdit1")
	_input_field_2 = get_node_or_null("Panel/VBoxContainer/HBoxContainer/LineEdit2")

func _on_submit() -> void:
	if not _input_field or not _input_field_2 or not _feedback:
		return
	var ans1 := _input_field.text.strip_edges()
	var ans2 := _input_field_2.text.strip_edges()
	# Check if both answers match
	if [ans1, ans2] == correct_codes:
		_feedback.text = success_message
		_feedback.modulate = Color(0.2, 0.8, 0.2)
		await get_tree().create_timer(2.0).timeout
		close_ui()
	else:
		_feedback.text = wrong_message
		_feedback.modulate = Color(0.8, 0.2, 0.2)
		_input_field.text = ""
		_input_field_2.text = ""
