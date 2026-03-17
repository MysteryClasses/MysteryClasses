extends "res://scenes/rooms/hidden_objects_room/hidden_room_ui_base.gd"

enum UIType {
	BOARD,
	SEQUENCE,
	WRONG_OBJECT,
}

@export var ui_type: UIType = UIType.BOARD
@export var clue_id: String = "hidden_objects_room_board_clue"
@export var challenge_id: String = "hidden_objects_room_desk_sequence"
@export var expected_step_index: int = 0
@export var total_steps: int = 3
@export var title_text: String = "Hidden Room Clue"
@export_multiline var body_text: String = ""
@export_multiline var hint_text: String = "Start with the study clue, then art, then snack."
@export_multiline var sequence_success_message: String = "Correct clue."
@export_multiline var sequence_wrong_message: String = "Wrong order. Start again from the first clue."
@export_multiline var board_required_message: String = "Inspect the board before interacting with the room clues."
@export_multiline var solved_message: String = "This sequence is already solved."
@export_multiline var wrong_object_board_message: String = "This is not part of the clue. Inspect the board first."
@export_multiline var wrong_object_solved_message: String = "The sequence is already solved. This object is just a distraction."

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
	if current_step == expected_step_index:
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


func _build_board_status_text() -> String:
	if _game_manager().is_challenge_solved(challenge_id):
		return "Sequence complete. The exit is unlocked."

	var progress: int = _game_manager().get_challenge_progress(challenge_id)
	return "Current progress: %d/%d. %s" % [progress, total_steps, hint_text]
