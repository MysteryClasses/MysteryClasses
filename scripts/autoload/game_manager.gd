extends Node

# Tracks which clues the player has found (by unique ID)
var collected_clues: Array[String] = []

# Tracks which challenges the player has solved (by unique ID)
var solved_challenges: Array[String] = []
var challenge_progress: Dictionary = {}
var challenge_collected_tokens: Dictionary = {}
var challenge_collected_items: Dictionary = {}

# For future: Checks if player has a certain clue
func has_clue(clue_id: String) -> bool:
	return clue_id in collected_clues

# Adds clue to player's clue list
func collect_clue(clue_id: String) -> void:
	if not has_clue(clue_id):
		collected_clues.append(clue_id)

# Checks if a certain Challenge is solved
func is_challenge_solved(challenge_id: String) -> bool:
	return challenge_id in solved_challenges

# Adds Challenge to solved Challenges
func solve_challenge(challenge_id: String) -> void:
	if not is_challenge_solved(challenge_id):
		solved_challenges.append(challenge_id)


func get_challenge_progress(challenge_id: String) -> int:
	return int(challenge_progress.get(challenge_id, 0))


func set_challenge_progress(challenge_id: String, progress: int) -> void:
	challenge_progress[challenge_id] = progress


func reset_challenge_progress(challenge_id: String) -> void:
	challenge_progress.erase(challenge_id)


func get_challenge_tokens(challenge_id: String) -> Array[String]:
	var typed_tokens: Array[String] = []
	var stored_tokens: Array = challenge_collected_tokens.get(challenge_id, [])
	for token in stored_tokens:
		typed_tokens.append(String(token))
	return typed_tokens


func append_challenge_token(challenge_id: String, token: String) -> void:
	var tokens: Array[String] = get_challenge_tokens(challenge_id)
	tokens.append(token)
	challenge_collected_tokens[challenge_id] = tokens


func is_challenge_item_collected(challenge_id: String, item_id: String) -> bool:
	var items: Array[String] = _get_challenge_items(challenge_id)
	return item_id in items


func mark_challenge_item_collected(challenge_id: String, item_id: String) -> void:
	var items: Array[String] = _get_challenge_items(challenge_id)
	if item_id not in items:
		items.append(item_id)
	challenge_collected_items[challenge_id] = items


func reset_challenge_sequence(challenge_id: String) -> void:
	reset_challenge_progress(challenge_id)
	challenge_collected_tokens.erase(challenge_id)
	challenge_collected_items.erase(challenge_id)


func _get_challenge_items(challenge_id: String) -> Array[String]:
	var typed_items: Array[String] = []
	var stored_items: Array = challenge_collected_items.get(challenge_id, [])
	for item in stored_items:
		typed_items.append(String(item))
	return typed_items
