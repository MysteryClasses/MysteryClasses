extends Area2D

@export var target_scene: String

var player_inside = false


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(_delta):
	if player_inside and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file(target_scene)


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
