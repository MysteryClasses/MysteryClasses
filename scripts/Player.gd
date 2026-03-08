extends CharacterBody2D

# Bewegungsgeschwindigkeit
@export var speed: float = 300.0

# Speichert letzte Blickrichtung für Idle Animation
var last_direction: String = "down"
	
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
