extends ClueUIBase


func _initialize_ui(title_text: String) -> void:
	super._ready()
	var title_label := get_node_or_null("Panel/VBoxContainer/TitleLabel") as Label
	if title_label:
		title_label.text = title_text


func _game_manager() -> GameManager:
	return get_node("/root/GameManager")
