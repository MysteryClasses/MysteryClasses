extends Node

@export var enemy_scene_1: PackedScene
@export var enemy_scene_2: PackedScene

@export var survival_time: int = 15
@export var intro_time: float = 4.0

# Intro and win/loss messages shown in the chase room UI
@export_multiline var intro_message: String = "[The Shadow has sent two creatures to chase you. Survive for 15 seconds!]"
@export_multiline var win_message: String = "You survived! The darkness fades..."
@export_multiline var loss_message: String = "You got caught. You can feel your memory emptying..."

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

	# Show intro placeholder text for a few seconds before enemies spawn
	message_label.text = intro_message
	countdown_label.visible = false

	await get_tree().create_timer(intro_time).timeout

	if game_finished:
		return

	spawn_enemy()
	start_countdown()


func spawn_enemy() -> void:
	if enemy_scene_1 == null or enemy_scene_2 == null:
		push_warning("ChaseController: enemy scenes not assigned in Inspector")
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

	_free_enemies()
	countdown_label.visible = false
	message_label.text = win_message

	# Mark chase as survived so the locked door shows different text next time
	GameManager.chase_room_survived = true

	# Wait briefly so the player can read the win message, then return to hallway
	await get_tree().create_timer(3.0).timeout
	GameManager.target_spawn_id = "SpawnFromChaseRoom"
	get_tree().change_scene_to_file("res://scenes/rooms/hallway/hallway.tscn")


func _on_player_caught() -> void:
	if game_finished:
		return

	game_finished = true

	_free_enemies()
	countdown_label.visible = false
	message_label.text = loss_message

	# Reset ALL challenge progress — player must start over
	GameManager.reset_all_challenges()

	# Wait so the player can read the loss message, then return to hallway
	await get_tree().create_timer(3.0).timeout
	GameManager.target_spawn_id = "SpawnFromChaseRoom"
	get_tree().change_scene_to_file("res://scenes/rooms/hallway/hallway.tscn")


func _free_enemies() -> void:
	# Helper to safely remove both enemies at once
	if enemy_instance_1 != null and is_instance_valid(enemy_instance_1):
		enemy_instance_1.queue_free()
	if enemy_instance_2 != null and is_instance_valid(enemy_instance_2):
		enemy_instance_2.queue_free()
