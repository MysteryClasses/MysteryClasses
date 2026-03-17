extends "res://scenes/rooms/hidden_objects_room/hidden_room_ui_base.gd"

@export var required_challenge_id: String = "hidden_objects_room_desk_sequence"
@export var target_scene: String = "res://scenes/rooms/astro_room/astro_room.tscn"
@export_multiline var locked_message: String = "The exit is locked. A note points you to the board on the back wall before the marked objects can be understood."
@export_multiline var unlocked_message: String = "The word is complete. You can leave the room."

@onready var message_label: Label = $Panel/VBoxContainer/MessageLabel
@onready var action_button: Button = $Panel/VBoxContainer/ActionButton


func _ready() -> void:
	_initialize_ui("Exit Door")
	var is_unlocked: bool = _game_manager().is_challenge_solved(required_challenge_id)
	message_label.text = unlocked_message if is_unlocked else locked_message
	action_button.text = "Leave Room" if is_unlocked else "Locked"
	action_button.disabled = not is_unlocked
	action_button.pressed.connect(_on_action_button_pressed)


func _on_action_button_pressed() -> void:
	get_tree().paused = false
	var error := get_tree().change_scene_to_file(target_scene)
	if error != OK:
		push_error("ExitDoorUI: failed to change scene to '%s' (error %d)." % [target_scene, error])
