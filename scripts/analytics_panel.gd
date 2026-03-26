extends Control

@onready var scene_label = $"Panel/VBoxContainer/Scene Info"
@onready var music_label = $"Panel/VBoxContainer/Music Status"
@onready var item_label = $"Panel/VBoxContainer/Item Interactions"

func _ready():
	AnalyticsManager.analytics_updated.connect(update_ui)
	update_ui()

func update_ui():
	scene_label.text = "Current Scene: " + AnalyticsManager.current_scene_name
	music_label.text = "Music Enabled: " + str(AnalyticsManager.music_enabled)
	
	var text = "Item Interactions:\n"
	for item in AnalyticsManager.item_interactions.keys():
		text += item + ": " + str(AnalyticsManager.item_interactions[item]) + "\n"
	
	item_label.text = text
