extends Area2D

@export var object_id : String = "default_object"

func interact() -> void:
	AnalyticsManager.track_interaction(object_id)

	print("Interacted with: ", object_id)
