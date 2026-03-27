# Startbildschirm — zeigt Titel, Beschreibung und einen Start-Button
extends Control

func _ready() -> void:
	# Pausiert nicht, damit Eingaben verarbeitet werden
	process_mode = Node.PROCESS_MODE_ALWAYS
	$VBoxContainer/StartButton.pressed.connect(_on_start_pressed)

func _on_start_pressed() -> void:
	# Wechselt zur Hallway-Szene (Spielstart)
	get_tree().change_scene_to_file("res://scenes/rooms/hallway/hallway.tscn")
