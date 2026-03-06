extends CharacterBody2D

@export var speed: float = 300.0

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("move_up"):
		direction.y -= 1
	
	# Normalize diagonal movement and apply speed
	if direction.length() > 0:
		velocity = direction.normalized() * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()   
