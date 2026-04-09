extends Control

const INTRO_BEATS: Array[Dictionary] = [
	{
		"speaker": "Max",
		"text": "Where am I?",
		"reveal_after": true,
	},
	{
		"speaker": "Shadow",
		"text": "If you are looking for your friend, you will find answers in the hidden sites.",
	},
	{
		"speaker": "Shadow",
		"text": "Keep your eyes wide open and your mind sharp.",
	},
	{
		"speaker": "Max",
		"text": "But where should I start?",
	},
	{
		"speaker": "Shadow",
		"text": "There is the thing you use daily. Look around.",
	},
]

@export var next_scene_path: String = ""

var _beat_index: int = 0
var _shadow_revealed: bool = false

@onready var next_button: Button = $UiLayer/ButtonRow/NextButton
@onready var skip_button: Button = $UiLayer/ButtonRow/SkipButton
@onready var shadow_talking: Sprite2D = get_node_or_null("shadow_talking")
@onready var shadow_side: Sprite2D = get_node_or_null("shadow_side")
@onready var max_sprite: Sprite2D = $max_sprite
@onready var dialogue_max: Sprite2D = $dialogue_max
@onready var dialogue_shadow: Sprite2D = $dialogue_shadow
# Labels sind jetzt im DialogueLayer (CanvasLayer), unabhängig vom Sprite-Transform
@onready var dialogue_max_label: Label = $DialogueLayer/DialogueMaxLabel
@onready var dialogue_shadow_label: Label = $DialogueLayer/DialogueShadowLabel
@onready var darkness_overlay: ColorRect = $DarknessOverlay
@onready var spotlight_material: ShaderMaterial = darkness_overlay.material as ShaderMaterial
@onready var ambient_glow: ColorRect = $AmbientGlow


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if next_button:
		next_button.pressed.connect(_on_next_pressed)
	if skip_button:
		skip_button.pressed.connect(_finish_scene)
	for shadow_variant in _get_shadow_variants():
		shadow_variant.modulate.a = 0.0
		shadow_variant.visible = false
	max_sprite.visible = true
	dialogue_max.visible = false
	dialogue_shadow.visible = false
	ambient_glow.modulate.a = 0.08
	_set_spotlight_radius(1.05)
	_update_dialogue()
	_play_intro()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"):
		_on_next_pressed()
	elif event.is_action_pressed("ui_cancel"):
		_finish_scene()


func _on_next_pressed() -> void:
	var current_beat: Dictionary = INTRO_BEATS[_beat_index]
	if bool(current_beat.get("reveal_after", false)) and not _shadow_revealed:
		_reveal_scene()

	if _beat_index >= INTRO_BEATS.size() - 1:
		_finish_scene()
		return

	_beat_index += 1
	_update_dialogue()
	if _shadow_revealed:
		_pulse_shadow()


func _update_dialogue() -> void:
	var beat: Dictionary = INTRO_BEATS[_beat_index]
	var speaker := String(beat.get("speaker", "Narration"))
	var text := String(beat.get("text", ""))
	dialogue_max_label.text = text if speaker == "Max" else ""
	dialogue_shadow_label.text = text if speaker == "Shadow" else ""
	next_button.text = "Leave" if _beat_index == INTRO_BEATS.size() - 1 else "Next"
	_update_shadow_pose(speaker)
	_update_dialogue_bubbles(speaker)


func _finish_scene() -> void:
	if not next_scene_path.is_empty():
		get_tree().change_scene_to_file(next_scene_path)
		return

	queue_free()


func _play_intro() -> void:
	modulate.a = 0.0

	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.35)


func _reveal_scene() -> void:
	_shadow_revealed = true

	var tween := create_tween()
	tween.tween_method(_set_spotlight_radius, 0.85, 1.1, 0.6)
	tween.parallel().tween_property(ambient_glow, "modulate:a", 0.12, 0.6)
	tween.parallel().tween_property(darkness_overlay, "modulate:a", 0.0, 0.8)
	for shadow_variant in _get_shadow_variants():
		tween.parallel().tween_property(shadow_variant, "modulate:a", 0.92, 0.75)


func _set_spotlight_radius(radius: float) -> void:
	if spotlight_material:
		spotlight_material.set_shader_parameter("radius", radius)


func _pulse_shadow() -> void:
	var active_shadow := _get_active_shadow()
	if active_shadow == null:
		return

	var tween := create_tween()
	var original_scale := active_shadow.scale
	tween.tween_property(active_shadow, "scale", original_scale * 1.03, 0.12)
	tween.tween_property(active_shadow, "scale", original_scale, 0.18)


func _update_shadow_pose(speaker: String) -> void:
	if not _shadow_revealed:
		return

	if shadow_talking:
		shadow_talking.visible = speaker == "Shadow"
	if shadow_side:
		shadow_side.visible = speaker == "Max"


func _update_dialogue_bubbles(speaker: String) -> void:
	dialogue_max.visible = speaker == "Max"
	dialogue_shadow.visible = speaker == "Shadow"


func _get_active_shadow() -> Sprite2D:
	for shadow_variant in _get_shadow_variants():
		if shadow_variant.visible:
			return shadow_variant
	return null


func _get_shadow_variants() -> Array[Sprite2D]:
	var variants: Array[Sprite2D] = []
	for shadow_variant in [shadow_talking, shadow_side]:
		if shadow_variant != null:
			variants.append(shadow_variant)
	return variants
