extends Node2D

@export var open_time: float = 5.0
@export var open_angle: float = 90.0

@onready var sprite: Sprite2D = $DoorPic
@onready var collision: CollisionShape2D = $Body/Collision
@onready var area: Area2D = $InteractArea

var player_in_range: CharacterBody2D = null
var is_open: bool = false
var is_busy: bool = false

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if player_in_range != null and not is_open and not is_busy:
			open_door(player_in_range)

func open_door(player: CharacterBody2D):
	is_busy = true
	is_open = true
	
	# Disable collision so player can walk through
	collision.disabled = true
	
	# Check if player is above or below
	var direction = sign(player.global_position.y - global_position.y)
	
	# If player exactly aligned, default to open downward
	if direction == 0:
		direction = 1
	
	var target_rotation = deg_to_rad(open_angle) * direction
	
	var tween = create_tween()
	tween.tween_property(sprite, "rotation", target_rotation, 0.3)
	tween.finished.connect(_after_open)

func _after_open():
	await get_tree().create_timer(open_time).timeout
	close_door()

func close_door():
	var tween = create_tween()
	tween.tween_property(sprite, "rotation", 0.0, 0.3)
	tween.finished.connect(_after_close)

func _after_close():
	is_open = false
	is_busy = false
	
	# Re-enable collision
	collision.disabled = false

func _on_body_entered(body):
	if body is CharacterBody2D:
		player_in_range = body

func _on_body_exited(body):
	if body == player_in_range:
		player_in_range = null
