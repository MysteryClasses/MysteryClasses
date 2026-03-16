extends Control

@export var clue_id: String = "hidden_objects_room_board_clue"
@export var challenge_id: String = "hidden_objects_room_desk_sequence"
@export var title_text: String = "Wrong Object"
@export_multiline var message_text: String = "Wrong object. Progress reset."

@onready var title_label: Label = $Panel/VBoxContainer/TitleLabel
@onready var message_label: Label = $Panel/VBoxContainer/MessageLabel
@onready var close_button: Button = $Panel/VBoxContainer/CloseButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	title_label.text = title_text
	message_label.text = _build_message()
	close_button.pressed.connect(close_ui)


func _build_message() -> String:
	if not _game_manager().has_clue(clue_id):
		return "This is not part of the clue. Inspect the board first."

	if _game_manager().is_challenge_solved(challenge_id):
		return "The sequence is already solved. This object is just a distraction."

	_game_manager().reset_challenge_progress(challenge_id)
	return message_text


func _game_manager() -> GameManager:
	return get_node("/root/GameManager")


func close_ui() -> void:
	get_tree().paused = false
	queue_free()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close_ui()
