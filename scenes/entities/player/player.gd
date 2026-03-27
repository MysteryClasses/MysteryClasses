extends CharacterBody2D

# Movement speed
@export var speed: float = 300.0
@export var player_tag := "test_session"

# Stores last movement direction for idle animation
var last_direction: String = "down"


func _ready():
	add_to_group("player")
	# call_deferred waits until the current frame is done before executing
	_apply_spawn_point.call_deferred()
	await _setup_talo()


func _setup_talo() -> void:
	# Only identify on the very first scene load - has_identity() is true afterwards
	# Repeated identify() calls cause 429 Rate Limit errors from Talo
	if not Talo.has_identity():
		if GameManager.talo_player_id.is_empty():
			GameManager.talo_player_id = Talo.players.generate_identifier()
		var player = await Talo.players.identify("anonymous", GameManager.talo_player_id)
		# Safety check: identify() returns null if it fails
		if player == null:
			push_warning("Talo identify failed - events will not be tracked")
			return
		Talo.current_player.set_prop("session_tag", player_tag)
	# Track scene name on every room change, then flush immediately
	# In the browser the tab is often just closed without a flush notification
	await Talo.events.track("SceneEntered", {"scene": get_tree().get_current_scene().name})
	await Talo.events.flush()


func _apply_spawn_point() -> void:
	# No spawn target set (e.g. at game start) -> position stays as defined in the editor
	if GameManager.target_spawn_id.is_empty():
		return
	# Search for the target node in the entire scene tree from root
	var spawn_node = get_tree().root.find_child(GameManager.target_spawn_id, true, false)
	if spawn_node:
		global_position = spawn_node.global_position
	else:
		push_warning("SpawnPoint '%s' not found in scene." % GameManager.target_spawn_id)
	# Consume once so it is not carried over to the next scene change
	GameManager.target_spawn_id = ""


func _physics_process(_delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	if direction.length() > 0:
		# normalized() ensures diagonal movement is not faster
		velocity = direction.normalized() * speed
		# abs() compares axis strengths - the dominant one wins
		if abs(direction.x) > abs(direction.y):
			last_direction = "right" if direction.x > 0 else "left"
		else:
			last_direction = "down" if direction.y > 0 else "up"
		$AnimatedSprite2D.play("move_" + last_direction)
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("idle_" + last_direction)

	move_and_slide()
