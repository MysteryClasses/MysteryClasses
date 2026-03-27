# Persistent HUD - always visible
extends Node

var _is_muted: bool = false
var _exit_dialog: ConfirmationDialog
var _summary_dialog: AcceptDialog
var _mute_btn: TextureButton
var _tex_on: Texture2D
var _tex_off: Texture2D

# All challenge IDs in the game - update this list when new challenges are added
const ALL_CHALLENGES: Array[String] = ["hallway_locker", "hidden_objects_room_desk_sequence"]
const ITCH_URL := "https://hendrik287.itch.io/mysteryclasses"
# Default volume at game start (0.0 = silent, 1.0 = 100%, 0.5 = 50%)
const DEFAULT_VOLUME := 0.5

func _ready() -> void:
	_mute_btn = $CanvasLayer/MarginContainer/VBoxContainer/MuteButton
	_exit_dialog = $CanvasLayer/ExitConfirmDialog
	_summary_dialog = $CanvasLayer/SummaryDialog
	_tex_on = load("res://assets/shared/icons/icon_audio_on.png")
	_tex_off = load("res://assets/shared/icons/icon_audio_off.png")
	_mute_btn.texture_normal = _tex_on
	_mute_btn.texture_pressed = _tex_on
	# Set volume to DEFAULT_VOLUME at game start
	AudioServer.set_bus_volume_db(0, linear_to_db(DEFAULT_VOLUME))
	_mute_btn.pressed.connect(_on_mute_pressed)
	$CanvasLayer/MarginContainer/VBoxContainer/ExitButton.pressed.connect(_on_exit_pressed)
	_exit_dialog.confirmed.connect(_on_exit_confirmed)
	# After summary is dismissed, reset progress and return to start screen
	_summary_dialog.confirmed.connect(_on_summary_closed)

func _on_mute_pressed() -> void:
	_is_muted = !_is_muted
	AudioServer.set_bus_mute(0, _is_muted)
	AnalyticsManager.track_event("MusicToggled", {"music_on": str(not _is_muted)})
	# Swap texture based on current state
	var tex = _tex_off if _is_muted else _tex_on
	_mute_btn.texture_normal = tex
	_mute_btn.texture_pressed = tex

func _on_exit_pressed() -> void:
	# Show confirmation dialog first
	_exit_dialog.popup_centered()

func _on_exit_confirmed() -> void:
	# Flush all pending events before showing the summary
	if Talo.has_identity():
		await Talo.events.flush()
	# Count solved challenges and build summary message
	var solved := 0
	for id in ALL_CHALLENGES:
		if GameManager.is_challenge_solved(id):
			solved += 1
	var total := ALL_CHALLENGES.size()
	var summary := "Solved Challenges: %d/%d\n\n" % [solved, total]
	if solved == total:
		summary += "Congratulations - you solved everything!"
	elif solved == 0:
		summary += "Well, better luck next time..."
	else:
		summary += "Good effort - so close!"
	_summary_dialog.dialog_text = summary
	_summary_dialog.popup_centered()

func _on_summary_closed() -> void:
	# Reset all game progress so a new session starts clean
	GameManager.collected_clues.clear()
	GameManager.solved_challenges.clear()
	GameManager.challenge_progress.clear()
	GameManager.challenge_collected_tokens.clear()
	GameManager.challenge_collected_items.clear()
	GameManager.target_spawn_id = ""
	GameManager.talo_player_id = ""
	# Unpause before switching scenes
	get_tree().paused = false
	# Go back to start screen - works in both browser and desktop
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
