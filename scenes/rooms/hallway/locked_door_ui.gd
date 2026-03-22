extends Control
# UI for the locked door — checks if all required challenges are solved

# Challenge IDs that must ALL be solved to unlock this door
@export var required_challenges: Array[String] = []
@export_multiline var locked_message: String = "The door is locked. Solve all challenges to proceed."
@export_multiline var unlocked_message: String = "To be continued..."

@onready var message_label: Label = $Panel/VBoxContainer/MessageLabel
@onready var progress_label: Label = $Panel/VBoxContainer/ProgressLabel
@onready var close_button: Button = $Panel/VBoxContainer/CloseButton


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
	message_label.text = unlocked_message if all_solved else locked_message
	progress_label.text = "Challenges solved: %d/%d" % [solved_count, required_challenges.size()]


func _close() -> void:
	get_tree().paused = false
	queue_free()


func _input(event: InputEvent) -> void:
	# Allow closing with ESC
	if event.is_action_pressed("ui_cancel"):
		_close()
