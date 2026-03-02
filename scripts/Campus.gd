extends Node2D

func _ready():
	# Connect entry area signal
	$EnglishClassEntry.body_entered.connect(_on_english_class_entry_body_entered)

func _on_english_class_entry_body_entered(body):
	if body.name == "Player":
		# Enter English classroom
		get_tree().change_scene_to_file("res://scenes/environments/EnglishClass.tscn")