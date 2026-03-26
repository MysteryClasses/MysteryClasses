extends Node

var item_count := 0

func on_item_interacted(item_id: String) -> void:
	item_count += 1
	await Talo.events.track("ItemInteracted", {
		"item_id": item_id,
		"scene_name": get_tree().get_current_scene().name,
		"count": str(item_count),
	})
