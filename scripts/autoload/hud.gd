# Persistent HUD — always visible
extends Node

# Tracks mute state so we can toggle it
var _is_muted: bool = false

func _ready() -> void:
	# Note: VBoxContainer, not HBoxContainer
	$CanvasLayer/MarginContainer/VBoxContainer/MuteButton.pressed.connect(_on_mute_pressed)
	$CanvasLayer/MarginContainer/VBoxContainer/ChallengesButton.pressed.connect(_on_challenges_pressed)
	$CanvasLayer/MarginContainer/VBoxContainer/MenuButton.pressed.connect(_on_menu_pressed)
	$AnalyticsPanel.hide()
	
func _on_mute_pressed() -> void:
	# Flip the state and apply it to the master bus (index 0)
	_is_muted = !_is_muted
	AudioServer.set_bus_mute(0, _is_muted)


	# Update button label so the player knows the current state
	var btn := $CanvasLayer/MarginContainer/VBoxContainer/MuteButton
	btn.text = "🔇" if _is_muted else "🔊"

func _input(event):
	if event.is_action_pressed("debug_analytics"):
		$AnalyticsPanel.visible = !$AnalyticsPanel.visible

func _on_challenges_pressed() -> void:
	pass

func _on_menu_pressed() -> void:
	pass
