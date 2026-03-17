extends ClueUIBase


func _initialize_ui(title_text: String) -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var close := get_node_or_null("Panel/VBoxContainer/CloseButton") as Button
	if close:
		close.pressed.connect(close_ui)
	var title_label := get_node_or_null("Panel/VBoxContainer/TitleLabel") as Label
	if title_label:
		title_label.text = title_text


func _game_manager() -> GameManager:
	return get_node("/root/GameManager")
