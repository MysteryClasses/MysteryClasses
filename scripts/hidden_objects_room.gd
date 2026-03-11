extends Node2D

# Puzzle state variables
var clue_read := false
var puzzle_solved := false
var current_step := 0

# The correct order of desks to interact with
var desk_order := ["Desk1", "Desk2", "Desk3"]

# Clue text to display
const CLUE_TEXT = "Study first, creativity second, hunger last."

# Called when the node enters the scene tree for the first time
func _ready():
	print("Hidden Objects Room puzzle initialized")
	print("Inspect the board to begin the puzzle...")

# Method called when the board is interacted with
func interact_with_board():
	if not clue_read:
		# First time reading the clue
		clue_read = true
		current_step = 0  # Reset desk sequence
		show_status_message("Board Clue: " + CLUE_TEXT)
		show_status_message("The puzzle has begun! Follow the clue to solve it.")
	else:
		# Remind player of the clue
		show_status_message("Board Clue: " + CLUE_TEXT)
		if puzzle_solved:
			show_status_message("Puzzle already solved!")
		else:
			show_status_message("Current progress: " + str(current_step) + "/" + str(desk_order.size()))

# Method called when any desk is interacted with
func interact_with_desk(desk_name: String):
	# Check if clue has been read first
	if not clue_read:
		show_status_message("Inspect the board first to understand what to do.")
		return
	
	# Check if puzzle is already solved
	if puzzle_solved:
		show_status_message("Puzzle already solved! The exit door is unlocked.")
		return
	
	# Check if this is the correct desk in the sequence
	var expected_desk = desk_order[current_step]
	
	if desk_name == expected_desk:
		# Correct desk!
		current_step += 1
		show_status_message("Correct! Interacted with " + desk_name + ". Progress: " + str(current_step) + "/" + str(desk_order.size()))
		
		# Check if puzzle is complete
		if current_step >= desk_order.size():
			puzzle_solved = true
			show_status_message("Puzzle solved! The exit door is unlocked.")
	else:
		# Wrong desk - reset progress but keep clue as read
		show_status_message("Wrong order! You interacted with " + desk_name + " but should have used " + expected_desk + ". Progress reset.")
		reset_puzzle_progress()

# Reset the puzzle progress (but keep clue as read)
func reset_puzzle_progress():
	current_step = 0
	# Note: clue_read remains true, puzzle_solved becomes false
	puzzle_solved = false
	show_status_message("Desk sequence reset. Remember the clue: " + CLUE_TEXT)

# Check if the puzzle is solved (useful for door/exit logic)
func is_puzzle_solved() -> bool:
	return puzzle_solved

# Method to attempt opening the exit door
func try_open_exit():
	if puzzle_solved:
		show_status_message("Exit door opened! You can leave the room.")
		# Automatically change scene or allow teleport
		get_tree().change_scene_to_file("res://scenes/rooms/astro_room/astro_room.tscn")
		return true
	else:
		show_status_message("The exit door is locked. Solve the puzzle first.")
		return false

# Helper method to show status messages (can be easily replaced with UI later)
func show_status_message(text: String):
	print("[Room Message] " + text)
	# TODO: Replace with actual UI label when ready
	# For now, also display a temporary label if needed
	display_temp_message(text)

# Temporary message display (you can enhance this with a proper UI later)
func display_temp_message(text: String):
	# This is a simple temporary solution - replace with proper UI
	var label = Label.new()
	label.text = text
	label.position = Vector2(100, 50)
	label.size = Vector2(800, 100)
	label.add_theme_color_override("font_color", Color.WHITE)
	add_child(label)
	
	# Remove the label after 3 seconds
	var timer = Timer.new()
	timer.wait_time = 3.0
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(func(): 
		if label and is_instance_valid(label):
			label.queue_free()
		if timer and is_instance_valid(timer):
			timer.queue_free()
	)
	timer.start()

# Helper method to get puzzle status for debugging
func get_puzzle_status() -> Dictionary:
	return {
		"clue_read": clue_read,
		"puzzle_solved": puzzle_solved,
		"current_step": current_step,
		"expected_next_desk": desk_order[current_step] if current_step < desk_order.size() else "None"
	}