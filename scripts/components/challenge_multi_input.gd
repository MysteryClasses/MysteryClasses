extends ClueUIBase
# Unterstützt beliebig viele Eingabefelder — Anzahl ergibt sich aus correct_codes.size()
# Nodes müssen LineEdit1, LineEdit2, LineEdit3, ... heißen

@export var correct_codes: Array[String] = []

var _input_fields: Array[LineEdit] = []  # Alle Felder dynamisch gesammelt

func _ready() -> void:
	super._ready()  # Basis-Setup aus ClueUIBase (findet SubmitButton, CloseButton etc.)
	# Alle LineEdit-Nodes dynamisch einsammeln: LineEdit1, LineEdit2, ...
	for i in range(correct_codes.size()):
		var field := get_node_or_null("Panel/VBoxContainer/HBoxContainer/LineEdit%d" % (i + 1))
		if field:
			_input_fields.append(field)

func _on_submit() -> void:
	if _input_fields.size() != correct_codes.size() or not _feedback:
		return

	# Alle Antworten in ein Array sammeln und mit correct_codes vergleichen
	var answers: Array[String] = []
	for field in _input_fields:
		answers.append(field.text.strip_edges())

	if answers == correct_codes:
		_feedback.text = success_message
		_feedback.modulate = Color(0.2, 0.8, 0.2)
		await get_tree().create_timer(2.0).timeout
		close_ui()
	else:
		_feedback.text = wrong_message
		_feedback.modulate = Color(0.8, 0.2, 0.2)
		# Alle Felder bei falscher Eingabe leeren
		for field in _input_fields:
			field.text = ""
