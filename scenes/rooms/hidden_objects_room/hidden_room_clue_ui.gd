extends "res://scenes/rooms/hidden_objects_room/hidden_room_ui_base.gd"

enum UIType {
	BOARD,
	SEQUENCE,
	WRONG_OBJECT,
	INFO,
	OBJECT_FRAGMENT,
}

@export var ui_type: UIType = UIType.BOARD
@export var clue_id: String = "hidden_objects_room_board_clue"
@export var challenge_id: String = "hidden_objects_room_desk_sequence"
@export var expected_step_index: int = 0
@export var valid_step_indices: PackedInt32Array = PackedInt32Array()
@export var total_steps: int = 3
@export var title_text: String = "Hidden Room Clue"
@export_multiline var body_text: String = ""
@export_multiline var hint_text: String = "The pattern loops through the clues in order."
@export_multiline var sequence_success_message: String = "Correct clue."
@export_multiline var sequence_wrong_message: String = "Wrong order. Start again from the first clue."
@export_multiline var board_required_message: String = "These clues are incomplete on their own. Read the board on the back wall first."
@export_multiline var solved_message: String = "This sequence is already solved."
@export_multiline var wrong_object_board_message: String = "This object means nothing yet. Read the board on the back wall first."
@export_multiline var wrong_object_solved_message: String = "The sequence is already solved. This object is just a distraction."
@export var fragment_id: String = ""
@export var fragment_character: String = ""
@export_multiline var info_text: String = ""
@export_multiline var fragment_success_message: String = "You collect a marked fragment."
@export_multiline var fragment_repeat_message: String = "You already collected this fragment."
@export_multiline var fragment_wrong_message: String = "That fragment does not fit yet. The sequence resets."
@export_multiline var fragment_board_message: String = "The mark on this object is meaningless without the board. Read the board on the back wall first."
@export_multiline var fragment_solved_message: String = "All fragments are already in place."

@onready var primary_label: Label = $Panel/VBoxContainer/PrimaryLabel
@onready var secondary_label: Label = $Panel/VBoxContainer/SecondaryLabel


func _ready() -> void:
	_initialize_ui(title_text)

	match ui_type:
		UIType.BOARD:
			_show_board_clue()
		UIType.SEQUENCE:
			_show_sequence_clue()
		UIType.WRONG_OBJECT:
			_show_wrong_object()
		UIType.INFO:
			_show_info()
		UIType.OBJECT_FRAGMENT:
			_show_object_fragment()


func _show_board_clue() -> void:
	_game_manager().collect_clue(clue_id)
	primary_label.text = body_text
	secondary_label.text = _build_board_status_text()
	secondary_label.visible = true


func _show_sequence_clue() -> void:
	secondary_label.visible = true

	if not _game_manager().has_clue(clue_id):
		primary_label.text = board_required_message
		secondary_label.text = "Progress: 0/%d" % total_steps
		return

	if _game_manager().is_challenge_solved(challenge_id):
		primary_label.text = solved_message
		secondary_label.text = "Progress: %d/%d. Exit unlocked." % [total_steps, total_steps]
		return

	var current_step: int = _game_manager().get_challenge_progress(challenge_id)
	if _matches_expected_step(current_step):
		var new_progress: int = current_step + 1
		_game_manager().set_challenge_progress(challenge_id, new_progress)
		primary_label.text = sequence_success_message
		if new_progress >= total_steps:
			_game_manager().solve_challenge(challenge_id)
			secondary_label.text = "Progress: %d/%d. Exit unlocked." % [total_steps, total_steps]
			return

		secondary_label.text = "Progress: %d/%d" % [new_progress, total_steps]
		return

	_game_manager().reset_challenge_progress(challenge_id)
	primary_label.text = sequence_wrong_message
	secondary_label.text = "Progress reset. Re-read the board clue and begin again."


func _show_wrong_object() -> void:
	secondary_label.visible = false

	if not _game_manager().has_clue(clue_id):
		primary_label.text = wrong_object_board_message
		return

	if _game_manager().is_challenge_solved(challenge_id):
		primary_label.text = wrong_object_solved_message
		return

	_game_manager().reset_challenge_progress(challenge_id)
	primary_label.text = body_text


func _show_info() -> void:
	primary_label.text = info_text if not info_text.is_empty() else body_text
	secondary_label.visible = false


func _show_object_fragment() -> void:
	secondary_label.visible = true

	if not _game_manager().has_clue(clue_id):
		primary_label.text = fragment_board_message
		secondary_label.text = _build_fragment_status_text()
		return

	if _game_manager().is_challenge_solved(challenge_id):
		primary_label.text = fragment_solved_message
		secondary_label.text = "Collected word: %s. Exit unlocked." % _build_collected_word()
		return

	if _game_manager().is_challenge_item_collected(challenge_id, fragment_id):
		primary_label.text = fragment_repeat_message
		secondary_label.text = _build_fragment_status_text()
		return

	var current_step: int = _game_manager().get_challenge_progress(challenge_id)
	if _matches_expected_step(current_step):
		var new_progress: int = current_step + 1
		_game_manager().set_challenge_progress(challenge_id, new_progress)
		_game_manager().append_challenge_token(challenge_id, fragment_character)
		_game_manager().mark_challenge_item_collected(challenge_id, fragment_id)
		primary_label.text = fragment_success_message
		if new_progress >= total_steps:
			_game_manager().solve_challenge(challenge_id)
			secondary_label.text = "Collected word: %s. Exit unlocked." % _build_collected_word()
			return

		secondary_label.text = _build_fragment_status_text()
		return

	_game_manager().reset_challenge_sequence(challenge_id)
	primary_label.text = fragment_wrong_message
	secondary_label.text = "Collected word: %s. The fragments scatter and the sequence resets." % _build_masked_word()


func _build_board_status_text() -> String:
	if _game_manager().is_challenge_solved(challenge_id):
		return "Sequence complete. The exit is unlocked."

	var progress: int = _game_manager().get_challenge_progress(challenge_id)
	return "Current progress: %d/%d. %s" % [progress, total_steps, hint_text]


func _build_fragment_status_text() -> String:
	return "Collected word: %s. Progress: %d/%d" % [
		_build_masked_word(),
		_game_manager().get_challenge_progress(challenge_id),
		total_steps
	]


func _build_collected_word() -> String:
	var tokens: Array[String] = _game_manager().get_challenge_tokens(challenge_id)
	return "".join(tokens)


func _build_masked_word() -> String:
	var word := _build_collected_word()
	var remaining: int = maxi(total_steps - word.length(), 0)
	return "%s%s" % [word, "_".repeat(remaining)]


func _matches_expected_step(current_step: int) -> bool:
	if valid_step_indices.is_empty():
		return current_step == expected_step_index

	return current_step in valid_step_indices
