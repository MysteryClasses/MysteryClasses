extends StaticBody2D
class_name Interactable

# UI scene to open when the player interacts
@export var ui_scene: PackedScene
@export var object_id: String = "default_object"

# Tracks whether the player is nearby and whether a UI is already open
var _player_in_range: bool = false
var _active_ui: Node = null

# Called once when the node is loaded into the scene
func _ready() -> void:
	add_to_group("interactable")
	$InteractArea.body_entered.connect(_on_body_entered)
	$InteractArea.body_exited.connect(_on_body_exited)

# Opens the UI if the player is nearby and presses the interact key
func _unhandled_input(event: InputEvent) -> void:
	if _player_in_range and event.is_action_pressed("interact"):
		_open_ui()

# Shows the InteractLabel when the player enters the area
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = true
		if get_node_or_null("InteractLabel"):
			$InteractLabel.visible = true

# Hides the InteractLabel when the player leaves the area
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		_player_in_range = false
		if get_node_or_null("InteractLabel"):
			$InteractLabel.visible = false

func _open_ui() -> void:
	if _active_ui != null or ui_scene == null:
		return
	# Track the interaction before opening the UI
	interact()
	_active_ui = ui_scene.instantiate()
	_active_ui.tree_exited.connect(_on_ui_closed, CONNECT_ONE_SHOT)
	# CanvasLayer keeps the popup centered on screen regardless of camera
	var canvas_layer := CanvasLayer.new()
	canvas_layer.add_child(_active_ui)
	get_tree().current_scene.add_child(canvas_layer)
	get_tree().paused = true

func _on_ui_closed() -> void:
	if _active_ui and _active_ui.get_parent():
		_active_ui.get_parent().queue_free()
	_active_ui = null

func interact() -> void:
	# Track interaction via AnalyticsManager
	AnalyticsManager.track_interaction(object_id)
