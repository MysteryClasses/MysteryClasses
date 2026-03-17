extends Control

@export var clue_id: String = "hidden_objects_room_board_clue"
@export var challenge_id: String = "hidden_objects_room_desk_sequence"
@export var title_text: String = "Board Clue"
@export_multiline var clue_text: String = "Study first, creativity second, hunger last."
@export var total_steps: int = 3
@export_multiline var order_hint_text: String = "Start with the study clue, then art, then snack."

@onready var title_label: Label = $Panel/VBoxContainer/TitleLabel
@onready var clue_label: Label = $Panel/VBoxContainer/ClueLabel
@onready var status_label: Label = $Panel/VBoxContainer/StatusLabel
@onready var close_button: Button = $Panel/VBoxContainer/CloseButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_game_manager().collect_clue(clue_id)

	title_label.text = title_text
	clue_label.text = clue_text
	status_label.text = _build_status_text()
	close_button.pressed.connect(close_ui)


func _build_status_text() -> String:
	if _game_manager().is_challenge_solved(challenge_id):
		return "Sequence complete. The exit is unlocked."

	var progress: int = _game_manager().get_challenge_progress(challenge_id)
	return "Current progress: %d/%d. %s" % [progress, total_steps, order_hint_text]


func _game_manager() -> GameManager:
	return get_node("/root/GameManager")


func close_ui() -> void:
	get_tree().paused = false
	queue_free()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close_ui()
