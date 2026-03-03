extends StaticBody2D

var player_in_range = false
var ui_scene = preload("res://scenes/ui/TextbookClue.tscn") # your TextbookClue scene

func _ready():
	# Connect signals for the interaction area
	$InteractionArea.body_entered.connect(_on_body_entered)
	$InteractionArea.body_exited.connect(_on_body_exited)

func _input(event):
	# Only open clue if player is in range and presses interact
	if player_in_range and event.is_action_pressed("interact"):
		open_puzzle_ui()

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		if $InteractionLabel:
			$InteractionLabel.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		if $InteractionLabel:
			$InteractionLabel.visible = false

func open_puzzle_ui():
	# Instantiate the TextbookClue scene
	if not ui_scene:
		print("Error: TextbookClue scene not loaded")
		return

	var ui_instance = ui_scene.instantiate()
	get_tree().current_scene.add_child(ui_instance)
	# Pause the game while the popup is open
	get_tree().paused = true
