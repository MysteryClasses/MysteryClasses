extends StaticBody2D

@export var target_scene: String = "res://scenes/shadow_scene/shadow_scene.tscn"

var _player_in_range: bool = false


func _ready() -> void:
	$InteractArea.body_entered.connect(_on_body_entered)
	$InteractArea.body_exited.connect(_on_body_exited)
	$InteractLabel.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and event.is_action_pressed("interact") and not target_scene.is_empty():
		get_tree().change_scene_to_file(target_scene)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = true
		$InteractLabel.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = false
		$InteractLabel.visible = false
