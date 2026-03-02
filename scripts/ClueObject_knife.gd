extends StaticBody2D

var player_in_range = false
var ui_scene = preload("res://scenes/ui/CalendarClue.tscn")

func _ready():
	$InteractionArea.body_entered.connect(_on_interaction_area_body_entered)
	$InteractionArea.body_exited.connect(_on_interaction_area_body_exited)

func _input(event):
	if player_in_range and event.is_action_pressed("interact"):
		open_puzzle_ui()

func _on_interaction_area_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		$InteractionLabel.visible = true

func _on_interaction_area_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		$InteractionLabel.visible = false

func open_puzzle_ui():
	var ui_instance = ui_scene.instantiate()
	get_tree().current_scene.add_child(ui_instance)
	get_tree().paused = true