extends Node

var start_time : float
var scene_name : String

func _ready() -> void:
	start_time = Time.get_unix_time_from_system()
	scene_name = get_tree().current_scene.name


func _exit_tree() -> void:
	var end_time = Time.get_unix_time_from_system()
	var duration = end_time - start_time

	AnalyticsManager.track_scene_time(scene_name, duration)
