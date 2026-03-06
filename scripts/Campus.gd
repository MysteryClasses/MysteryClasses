extends Node2D

func _ready():
	# Connect entry area signal if the node exists in the current scene
	if has_node("EnglishClassEntry"):
		$EnglishClassEntry.body_entered.connect(_on_english_class_entry_body_entered)
	else:
		push_warning("Campus.gd: 'EnglishClassEntry' node not found; entry signal not connected.")

func _on_english_class_entry_body_entered(body):
	if body.name == "Player":
		# Enter English classroom if the scene resource exists
		var scene_path := "res://scenes/environments/EnglishClass.tscn"
		if ResourceLoader.exists(scene_path):
			get_tree().change_scene_to_file(scene_path)
		else:
			push_warning("Campus.gd: Scene '%s' not found; cannot change to English classroom." % scene_path)
