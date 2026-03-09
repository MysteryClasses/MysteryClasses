extends Node2D

@export var target_scene: String

@onready var area: Area2D = $InteractArea

var player_inside: bool = false


func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)


func _process(_delta):
	if player_inside and Input.is_action_just_pressed("interact"):
		if target_scene.is_empty():
			push_error("Teleport: target_scene is not set.")
			return
		var err = get_tree().change_scene_to_file(target_scene)
		if err != OK:
			push_error("Teleport: failed to change scene to '%s' (error %d)." % [target_scene, err])


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
