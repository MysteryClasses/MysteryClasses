extends CharacterBody2D


const speed = 30.0
var current_state = IDLE

var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false

enum {
	IDLE,
	MOVE,
	NEW_DIR
}

func _ready():
	randomize()
	start_pos = position
	
func _process(delta):
	if current_state ==0 or current_state ==1:
		$AnimatedSprite2D.play("idle")
	elif current_state == 2 and !is_chatting:
		if dir.x ==-1:
			$AnimatedSprite2D.play("walk_w")
		if dir.x ==1:
			$AnimatedSprite2D.play("walk_e")
		if dir.y == -1:
			$AnimatedSprite2D.play("walk_n")
		if dir.y == 1:
			$AnimatedSprite2D.play("walk_s")
	
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP])
			MOVE:
				move(delta)
				
	if Input.is_action_just_pressed("chat"):
		print("chatting with npc")
		is_roaming = false
		is_chatting = true
		$AnimatedSprite2D.play("idle")
		

func choose(array):
	array.shuffle()
	return array.front()
	
func move(delta):
	if !is_chatting:
		position += dir * speed * delta


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player = body
		player_in_chat_zone = true
	
func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		player_in_chat_zone = false
	
func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5, 1, 1.5, 2])
	current_state = choose([IDLE, NEW_DIR, MOVE])
