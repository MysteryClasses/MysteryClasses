extends Control
# UI for the locked door — checks if all required challenges are solved

# Challenge IDs that must ALL be solved to unlock this door
@export var required_challenges: Array[String] = []
@export_multiline var locked_message: String = "The door is locked. Solve all challenges to proceed."

# Shown when challenges are done but the chase room hasn't been survived yet
@export_multiline var unlocked_message: String = "You hear a click. The door swings open...\nBut something feels wrong."

# Shown after the player already survived the chase room
@export_multiline var survived_message: String = "[You made it. What lies beyond the door now?]"

@onready var message_label: Label = $Panel/VBoxContainer/MessageLabel
@onready var progress_label: Label = $Panel/VBoxContainer/ProgressLabel
@onready var close_button: Button = $Panel/VBoxContainer/CloseButton

# True when all challenges are solved and the chase room has NOT been survived yet
var _should_enter_chase: bool = false


func _ready() -> void:
	# Ensures this UI works while the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	close_button.pressed.connect(_close)

	# Count how many of the required challenges are already solved
	var solved_count := 0
	for challenge_id in required_challenges:
		if GameManager.is_challenge_solved(challenge_id):
			solved_count += 1

	var all_solved := solved_count == required_challenges.size()
	progress_label.text = "Challenges solved: %d/%d" % [solved_count, required_challenges.size()]

	if not all_solved:
		# Door still locked — show hint
		message_label.text = locked_message
		_should_enter_chase = false
	elif GameManager.chase_room_survived:
		# Player already survived — show placeholder "after" text
		message_label.text = survived_message
		_should_enter_chase = false
	else:
		# All solved, chase room not yet survived — player gets pulled in
		message_label.text = unlocked_message
		_should_enter_chase = true


func _close() -> void:
	get_tree().paused = false
	Talo.events.flush()
	queue_free()

	if _should_enter_chase:
		# Spawn the player at the designated marker inside the chase room
		GameManager.target_spawn_id = "ChaseRoomSpawn"
		get_tree().change_scene_to_file("res://scenes/rooms/chase_room/chase_room.tscn")


func _input(event: InputEvent) -> void:
	# Allow closing with ESC
	if event.is_action_pressed("ui_cancel"):
		_close()
