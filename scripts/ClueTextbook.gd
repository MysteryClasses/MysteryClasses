extends StaticBody2D

var player_in_range = false
var ui_scene = preload("res://scenes/ui/TextbookClue.tscn")
var _ui_instance = null

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
	if is_instance_valid(_ui_instance):
		return
	_ui_instance = ui_scene.instantiate()
	_ui_instance.tree_exiting.connect(func(): _ui_instance = null, CONNECT_ONE_SHOT)
	get_tree().current_scene.add_child(_ui_instance)
	get_tree().paused = true
