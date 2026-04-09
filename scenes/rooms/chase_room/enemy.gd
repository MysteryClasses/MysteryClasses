extends CharacterBody2D

signal player_caught

@export var speed: float = 225.0

@onready var navigation_agent_2d: NavigationAgent2D = $Navigation/NavigationAgent2D
@onready var catch_area: Area2D = $Area2D
@onready var graphic: Node2D = $Graphic

var player: Node2D = null
var active: bool = true


func _ready() -> void:
	# Sprite auf gleiche Größe wie den Player skalieren (16x24 px Tiles → 2x)
	graphic.scale = Vector2(2.0, 2.0)

	player = get_tree().get_first_node_in_group("player")

	if player == null:
		push_warning("Player not found in group 'player'")

	catch_area.body_entered.connect(_on_area_body_entered)


func _physics_process(_delta: float) -> void:
	if not active:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if player == null:
		return

	navigation_agent_2d.target_position = player.global_position

	var next_pos = navigation_agent_2d.get_next_path_position()
	var direction = next_pos - global_position

	if direction.length() > 1.0:
		velocity = direction.normalized() * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func stop_enemy() -> void:
	active = false
	velocity = Vector2.ZERO


func _on_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_caught.emit()
