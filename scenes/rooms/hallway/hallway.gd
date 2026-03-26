extends Node2D


func _ready():
	AnalyticsManager.enter_scene(name)

func _exit_tree():
	AnalyticsManager.exit_scene()
