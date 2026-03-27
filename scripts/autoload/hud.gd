# Persistent HUD — always visible
extends Node

# Tracks mute state so we can toggle it
var _is_muted: bool = false

func _ready() -> void:
	$CanvasLayer/MarginContainer/VBoxContainer/MuteButton.pressed.connect(_on_mute_pressed)
	
func _on_mute_pressed() -> void:
	# Flip the state and apply it to the master bus (index 0)
	_is_muted = !_is_muted
	AudioServer.set_bus_mute(0, _is_muted)


	# Update button label so the player knows the current state
	var btn := $CanvasLayer/MarginContainer/VBoxContainer/MuteButton
	btn.text = "🔇" if _is_muted else "🔊"
