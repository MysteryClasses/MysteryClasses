extends Area2D

# Reference to the root room script
var room_script

# Name of this interactable object
@export var object_name: String = ""

# Track if player is in range
var player_in_range: bool = false

func _ready():
	# Add to interactable group for easier detection
	add_to_group("interactable")
	
	# Get reference to the root room script
	room_script = get_node("../../..")  # Navigate up to Hidden_Objects_Room
	
	# Connect body enter/exit signals
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	
	# Connect the input_event signal for mouse clicks (backup method)
	connect("input_event", _on_input_event)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func _on_input_event(viewport, event, shape_idx):
	# Check for left mouse button click (backup interaction method)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact()

# Main interaction method - called by player or mouse click
func interact():
	if not room_script:
		print("Error: Could not find room script")
		return
	
	# Call appropriate interaction method based on object name
	match object_name:
		"Board":
			room_script.interact_with_board()
		"Desk1", "Desk2", "Desk3":
			room_script.interact_with_desk(object_name)
		_:
			print("Unknown object: " + object_name)
