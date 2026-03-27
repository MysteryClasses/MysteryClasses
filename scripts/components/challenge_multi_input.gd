extends ClueUIBase
# Supports N input fields - count is derived from correct_codes.size()
# Nodes must be named LineEdit1, LineEdit2, LineEdit3, ...

@export var correct_codes: Array[String] = []
@export var challenge_id: String = ""

var _input_fields: Array[LineEdit] = []

func _ready() -> void:
	super._ready()
	# Dynamically collect all LineEdit nodes: LineEdit1, LineEdit2, ...
	for i in range(correct_codes.size()):
		var field := get_node_or_null("Panel/VBoxContainer/HBoxContainer/LineEdit%d" % (i + 1))
		if field:
			_input_fields.append(field)

func _on_submit() -> void:
	if _input_fields.size() != correct_codes.size() or not _feedback:
		return

	# Collect all answers and compare with correct_codes
	var answers: Array[String] = []
	for field in _input_fields:
		answers.append(field.text.strip_edges())

	if answers == correct_codes:
		# Inform GameManager that this challenge is solved
		if not challenge_id.is_empty():
			GameManager.solve_challenge(challenge_id)
			# Track challenge completion in Talo
			AnalyticsManager.track_event("ChallengeSolved", {"challenge_id": challenge_id})
		_feedback.text = success_message
		_feedback.modulate = Color(0.2, 0.8, 0.2)
		await get_tree().create_timer(2.0).timeout
		close_ui()
	else:
		_feedback.text = wrong_message
		_feedback.modulate = Color(0.8, 0.2, 0.2)
		# Clear all fields on wrong input
		for field in _input_fields:
			field.text = ""
