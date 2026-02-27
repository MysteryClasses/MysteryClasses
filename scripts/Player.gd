extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_height: float = 20

var vertical_velocity: float = 0.0

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	# Move the player
	velocity = direction.normalized() * speed
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_accept"):
		jump()


func jump():
	print("Player jumps!")
	position.y -= jump_height   # move visually up
	await get_tree().create_timer(0.1).timeout   # wait 0.1 seconds
	position.y += jump_height   # move back down
