extends StaticBody2D

var player_in_range = false
var ui_scene = preload("res://scenes/ui/ChallengeOne.tscn")
var _active_ui = null

func _ready():
	$InteractionArea.body_entered.connect(_on_interaction_area_body_entered)
	$InteractionArea.body_exited.connect(_on_interaction_area_body_exited)

func _input(event):
	if player_in_range and event.is_action_pressed("interact"):
		open_puzzle_ui()

func _on_interaction_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		$InteractionLabel.visible = true

func _on_interaction_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		$InteractionLabel.visible = false

func open_puzzle_ui():
	if _active_ui != null:
		return
	var ui_instance = ui_scene.instantiate()
	_active_ui = ui_instance
	ui_instance.tree_exited.connect(_on_ui_closed, CONNECT_ONE_SHOT)
	get_tree().current_scene.add_child(ui_instance)
	get_tree().paused = true

func _on_ui_closed():
	_active_ui = null
