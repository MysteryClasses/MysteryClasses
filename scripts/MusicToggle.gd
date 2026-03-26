extends Node

func on_music_toggled(enabled: bool) -> void:
	await Talo.events.track("MusicToggled", {"music_on": str(enabled)})
