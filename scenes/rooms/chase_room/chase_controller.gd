extends Node

@export var enemy_scene_1: PackedScene
@export var enemy_scene_2: PackedScene

@export var survival_time: int = 30
@export var intro_time: float = 3.0

@onready var player = $"../Player"
@onready var enemy_spawn_point_1 = $"../EnemySpawnPoint1"
@onready var enemy_spawn_point_2 = $"../EnemySpawnPoint2"

@onready var message_label = $"../UI/MessageLabel"
@onready var countdown_label = $"../UI/CountdownLabel"

var enemy_instance_1: Node = null
var enemy_instance_2: Node = null

var game_finished: bool = false


func _ready() -> void:
	start_challenge()


func start_challenge() -> void:
	game_finished = false
	
	message_label.text = "Run for 30 seconds from the enemy to survive"
	countdown_label.visible = false
	
	await get_tree().create_timer(intro_time).timeout
	
	if game_finished:
		return
	
	spawn_enemy()
	start_countdown()


func spawn_enemy() -> void:
	if enemy_scene_1 == null or enemy_scene_2 == null:
		push_warning("Enemy scenes not assigned")
		return
	
	enemy_instance_1 = enemy_scene_1.instantiate()
	enemy_instance_2 = enemy_scene_2.instantiate()

	enemy_instance_1.global_position = enemy_spawn_point_1.global_position
	enemy_instance_2.global_position = enemy_spawn_point_2.global_position

	get_tree().current_scene.add_child(enemy_instance_1)
	get_tree().current_scene.add_child(enemy_instance_2)

	if enemy_instance_1.has_signal("player_caught"):
		enemy_instance_1.player_caught.connect(_on_player_caught)

	if enemy_instance_2.has_signal("player_caught"):
		enemy_instance_2.player_caught.connect(_on_player_caught)


func start_countdown() -> void:
	countdown_label.visible = true
	
	for time_left in range(survival_time, 0, -1):
		if game_finished:
			return
		
		message_label.text = ""
		countdown_label.text = str(time_left)
		
		await get_tree().create_timer(1.0).timeout
	
	if game_finished:
		return
	
	win_game()


func win_game() -> void:
	game_finished = true
	
	countdown_label.visible = false
	message_label.text = "Congratulations, you survived!"
	
	if enemy_instance_1 != null and is_instance_valid(enemy_instance_1):
		enemy_instance_1.queue_free()
		
	if enemy_instance_2 != null and is_instance_valid(enemy_instance_2):
		enemy_instance_2.queue_free()


func _on_player_caught() -> void:
	if game_finished:
		return
	
	game_finished = true
	
	countdown_label.visible = false
	message_label.text = "Game Over"
	
	if enemy_instance_1 != null and is_instance_valid(enemy_instance_1):
		enemy_instance_1.queue_free()
		
	if enemy_instance_2 != null and is_instance_valid(enemy_instance_2):
		enemy_instance_2.queue_free()
