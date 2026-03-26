extends CharacterBody2D

# Bewegungsgeschwindigkeit
@export var speed: float = 300.0
@export var player_tag := "test_session" 

# Speichert letzte Blickrichtung für Idle Animation
var last_direction: String = "down"



func _ready():
	add_to_group("player")
	# call_deferred wartet bis der aktuelle Frame fertig ist — dann ist
	# current_scene garantiert gesetzt und alle Nodes sind im Baum
	_apply_spawn_point.call_deferred()
	await Talo.players.identify("anonymous", Talo.players.generate_identifier())
	Talo.current_player.set_prop("session_tag", player_tag)
	await Talo.events.track("GameStarted", {"scene": get_tree().get_current_scene().name})



func _apply_spawn_point() -> void:
	# Kein Spawn-Ziel gesetzt (z.B. beim Spielstart) → Position bleibt wie im Editor
	if GameManager.target_spawn_id.is_empty():
		return
	# Suche den Ziel-Node im gesamten Szenenbaum ab Root
	var spawn_node = get_tree().root.find_child(GameManager.target_spawn_id, true, false)
	if spawn_node:
		global_position = spawn_node.global_position
	else:
		push_warning("SpawnPoint '%s' not found in scene." % GameManager.target_spawn_id)
	# Einmalig verbrauchen, damit es nicht zum nächsten Szenenwechsel mitgenommen wird
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
		# normalized() damit diagonale Bewegung nicht schneller ist
		velocity = direction.normalized() * speed

		# abs() vergleicht die Stärke der Achsen — die dominante gewinnt
		if abs(direction.x) > abs(direction.y):
			last_direction = "right" if direction.x > 0 else "left"
		else:
			last_direction = "down" if direction.y > 0 else "up"

		$AnimatedSprite2D.play("move_" + last_direction)
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("idle_" + last_direction)

	move_and_slide()
