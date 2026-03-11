extends CharacterBody2D

# Bewegungsgeschwindigkeit
@export var speed: float = 300.0

# Speichert letzte Blickrichtung für Idle Animation
var last_direction: String = "down"

func _ready():
	# Ensure player is in the player group for teleports and interactions
	add_to_group("player")

func _physics_process(delta):
	# Richtungsvektor für gedrückte Tasten
	var direction = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1

	# Spieler bewegt sich
	if direction.length() > 0:
		# normalized() damit diagonale Bewegung nicht schneller sind.
		# Ohne normalized() wäre der Vektor bei z.B. rechts+unten ca. 1.41 lang
		# statt 1.0, und der Spieler würde schneller laufen.
		velocity = direction.normalized() * speed

		# abs() vergleicht die Stärke der Achsen, damit bei diagonaler
		# Bewegung die dominantere Richtung für die Animation gewinnt.
		if abs(direction.x) > abs(direction.y):
			last_direction = "right" if direction.x > 0 else "left"
		else:
			last_direction = "down" if direction.y > 0 else "up"

		# Passende Lauf-Animation abspielen (z.B. "walk_right", "walk_up")
		$AnimatedSprite2D.play("move_" + last_direction)
	else:
		# Spieler steht still
		velocity = Vector2.ZERO

		# Idle-Animation in die letzte Blickrichtung abspielen
		$AnimatedSprite2D.play("idle_" + last_direction)

	# kümmert sich automatisch um Kollisionen
	move_and_slide()
	
	# Handle interaction input
	if Input.is_action_just_pressed("interact"):
		handle_interaction()

# Handle interaction with nearby objects
func handle_interaction():
	# Get all areas the player is overlapping with
	var areas = []
	var bodies = get_slide_collision_count()
	
	# Alternative approach: find all Area2D nodes that might be interactable
	var interactable_areas = get_tree().get_nodes_in_group("interactable")
	
	# If no grouped areas, search for nearby Area2D nodes
	if interactable_areas.is_empty():
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = global_position
		query.collision_mask = 2  # Layer 2 for interaction areas
		
		var results = space_state.intersect_point(query)
		for result in results:
			var collider = result["collider"]
			if collider.get_parent() is Area2D:
				interactable_areas.append(collider.get_parent())
	
	# Try to interact with the first available area
	for area in interactable_areas:
		if area.has_method("interact"):
			# Check if player is close enough
			var distance = global_position.distance_to(area.global_position)
			if distance < 100:  # Within interaction range
				area.interact()
				break
