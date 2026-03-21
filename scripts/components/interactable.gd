extends StaticBody2D
class_name Interactable

# UI scene to open when the player interacts
@export var ui_scene: PackedScene

# State-Variables to check if player is close
# or if the UI is open
var _player_in_range: bool = false
var _active_ui: Node = null

# Gets called once when node is being loaded
# into the scene
func _ready() -> void:
	# adds this node to the Group "interactable"
	add_to_group("interactable")
	# call func _on_body_[...] when player enters/exits area
	$InteractArea.body_entered.connect(_on_body_entered)
	$InteractArea.body_exited.connect(_on_body_exited)

# Opens ui if player is close and presses key to interact
func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and event.is_action_pressed("interact"):
		_open_ui()

# Shows InteractLabel if player is close
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = true
		if get_node_or_null("InteractLabel"):
			$InteractLabel.visible = true

# Stops showing InteractLabel if player leaves
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = false
		if get_node_or_null("InteractLabel"):
			$InteractLabel.visible = true

func _open_ui() -> void:
	if _active_ui != null or ui_scene == null:
		return
	_active_ui = ui_scene.instantiate()
	_active_ui.tree_exited.connect(_on_ui_closed, CONNECT_ONE_SHOT)
	# CanvasLayer keeps the popup centered on screen
	var canvas_layer := CanvasLayer.new()
	canvas_layer.add_child(_active_ui)
	get_tree().current_scene.add_child(canvas_layer)
	# Pauses the game unless specified otherwise
	get_tree().paused = true

func _on_ui_closed() -> void:
	if _active_ui and _active_ui.get_parent():
		_active_ui.get_parent().queue_free()
	_active_ui = null
