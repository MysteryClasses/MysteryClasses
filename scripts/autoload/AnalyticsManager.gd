extends Node

@export var player_tag := "test_session"

var session_id: String
var interaction_counts := {}

# Timer that flushes events periodically - important for the browser,
# since tab-close notifications are unreliable there
var _flush_timer: Timer
const FLUSH_INTERVAL_SECONDS := 3.0


func _ready() -> void:
	session_id = str(Time.get_unix_time_from_system())
	# Start the periodic flush timer
	_flush_timer = Timer.new()
	_flush_timer.wait_time = FLUSH_INTERVAL_SECONDS
	_flush_timer.autostart = true
	_flush_timer.timeout.connect(_on_flush_timer_timeout)
	add_child(_flush_timer)


func _on_flush_timer_timeout() -> void:
	# Only flush if there are events queued and a player is identified
	if Talo.has_identity() and Talo.events.get_queue_size() > 0:
		await Talo.events.flush()


func track_event(event_name: String, props: Dictionary = {}) -> void:
	var fixed_props: Dictionary[String, String] = {}
	for key in props.keys():
		fixed_props[str(key)] = str(props[key])
	fixed_props["session_id"] = str(session_id)
	fixed_props["player_tag"] = str(player_tag)
	await Talo.events.track(event_name, fixed_props)


func track_scene_time(scene_name: String, duration: float) -> void:
	await track_event("scene_time_spent", {
		"scene": scene_name,
		"duration_seconds": duration
	})


func track_interaction(object_id: String) -> void:
	if not interaction_counts.has(object_id):
		interaction_counts[object_id] = 0
	interaction_counts[object_id] += 1
	await track_event("object_interacted", {
		"object_id": object_id,
		"interaction_count": interaction_counts[object_id]
	})
