extends Control

@export var clue_id: String = "hidden_objects_room_board_clue"
@export var challenge_id: String = "hidden_objects_room_desk_sequence"
@export var expected_step_index: int = 0
@export var total_steps: int = 3
@export var title_text: String = "Sequence Clue"
@export_multiline var success_message: String = "Correct clue."
@export_multiline var wrong_message: String = "Wrong order. Start again from the first clue."

@onready var title_label: Label = $Panel/VBoxContainer/TitleLabel
@onready var message_label: Label = $Panel/VBoxContainer/MessageLabel
@onready var progress_label: Label = $Panel/VBoxContainer/ProgressLabel
@onready var close_button: Button = $Panel/VBoxContainer/CloseButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	title_label.text = title_text
	close_button.pressed.connect(close_ui)
	_apply_sequence_step()


func _apply_sequence_step() -> void:
	if not _game_manager().has_clue(clue_id):
		message_label.text = "Inspect the board before interacting with the room clues."
		progress_label.text = "Progress: 0/%d" % total_steps
		return

	if _game_manager().is_challenge_solved(challenge_id):
		message_label.text = "This sequence is already solved."
		progress_label.text = "Progress: %d/%d. Exit unlocked." % [total_steps, total_steps]
		return

	var current_step: int = _game_manager().get_challenge_progress(challenge_id)
	if current_step == expected_step_index:
		var new_progress: int = current_step + 1
		_game_manager().set_challenge_progress(challenge_id, new_progress)
		if new_progress >= total_steps:
			_game_manager().solve_challenge(challenge_id)
			message_label.text = success_message
			progress_label.text = "Progress: %d/%d. Exit unlocked." % [total_steps, total_steps]
			return

		message_label.text = success_message
		progress_label.text = "Progress: %d/%d" % [new_progress, total_steps]
		return

	_game_manager().reset_challenge_progress(challenge_id)
	message_label.text = wrong_message
	progress_label.text = "Progress reset. Re-read the board clue and begin again."


func _game_manager() -> GameManager:
	return get_node("/root/GameManager")


func close_ui() -> void:
	get_tree().paused = false
	queue_free()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close_ui()
