extends Node

@export var player_tag := "test_session"


var session_id : String
var interaction_counts := {}

func _ready() -> void:
	session_id = str(Time.get_unix_time_from_system())

func track_event(event_name:String, props:Dictionary = {}) -> void:
	var fixed_props: Dictionary[String, String] = {}

	for key in props.keys():
		fixed_props[str(key)] = str(props[key])

	fixed_props["session_id"] = str(session_id)
	fixed_props["player_tag"] = str(player_tag)

	await Talo.events.track(event_name, fixed_props)


func track_scene_time(scene_name:String, duration:float) -> void:
	await track_event("scene_time_spent", {
		"scene": scene_name,
		"duration_seconds": duration
	})



func track_interaction(object_id:String) -> void:
	if not interaction_counts.has(object_id):
		interaction_counts[object_id] = 0

	interaction_counts[object_id] += 1

	await track_event("object_interacted", {
		"object_id": object_id,
		"interaction_count": interaction_counts[object_id]
	})
