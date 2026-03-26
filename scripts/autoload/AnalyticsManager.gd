extends Node

var item_interactions = {}

var scene_enter_time = 0
var current_scene_name = ""

# Store music state
var music_enabled = true

signal analytics_updated

func _ready():
	scene_enter_time = Time.get_ticks_msec()

func enter_scene(scene_name):
	current_scene_name = scene_name
	scene_enter_time = Time.get_ticks_msec()

func exit_scene():
	var leave_time = Time.get_ticks_msec()
	var duration = (leave_time - scene_enter_time) / 1000.0
	
	track_event("scene_time_spent", {
		"scene": current_scene_name,
		"duration_seconds": duration
	})
	
	emit_signal("analytics_updated")


func track_item_interaction(item_name):
	if not item_interactions.has(item_name):
		item_interactions[item_name] = 0
	
	item_interactions[item_name] += 1
	
	track_event("item_interaction", {
		"item_name": item_name,
		"count": item_interactions[item_name]
	})
	
	emit_signal("analytics_updated")


func set_music_enabled(enabled):
	music_enabled = enabled
	
	track_event("music_toggle", {
		"enabled": enabled
	})
	
	emit_signal("analytics_updated")


func track_event(event_name, data):
	# Replace this with actual Talo call
	print("Send to Talo:", event_name, data)
