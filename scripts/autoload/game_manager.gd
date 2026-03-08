extends Node

# Tracks which clues the player has found (by unique ID)
var collected_clues: Array[String] = []

# Tracks which challenges the player has solved (by unique ID)
var solved_challenges: Array[String] = []

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
