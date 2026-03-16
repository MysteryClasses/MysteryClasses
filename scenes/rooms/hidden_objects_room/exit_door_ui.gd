extends Control

@export var required_challenge_id: String = "hidden_objects_room_desk_sequence"
@export var target_scene: String = "res://scenes/rooms/astro_room/astro_room.tscn"
@export_multiline var locked_message: String = "The exit is locked. Solve the hidden object sequence first."
@export_multiline var unlocked_message: String = "The sequence is solved. You can leave the room."

@onready var message_label: Label = $Panel/VBoxContainer/MessageLabel
@onready var action_button: Button = $Panel/VBoxContainer/ActionButton
@onready var close_button: Button = $Panel/VBoxContainer/CloseButton


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var is_unlocked: bool = _game_manager().is_challenge_solved(required_challenge_id)
	message_label.text = unlocked_message if is_unlocked else locked_message
	action_button.text = "Leave Room" if is_unlocked else "Locked"
	action_button.disabled = not is_unlocked
	action_button.pressed.connect(_on_action_button_pressed)
	close_button.pressed.connect(close_ui)


func _on_action_button_pressed() -> void:
	get_tree().paused = false
	var error := get_tree().change_scene_to_file(target_scene)
	if error != OK:
		push_error("ExitDoorUI: failed to change scene to '%s' (error %d)." % [target_scene, error])


func close_ui() -> void:
	get_tree().paused = false
	queue_free()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close_ui()


func _game_manager() -> Node:
	return get_node("/root/GameManager")
