# Draws a complete visual wall frame and creates collision bodies at runtime
@tool
extends Node2D

## Width and height of the frame in pixels
@export var frame_size: Vector2 = Vector2(600, 420):
	set(value):
		frame_size = value
		queue_redraw()

## Visual thickness of the wall lines
@export var line_thickness: float = 4.0:
	set(value):
		line_thickness = value
		queue_redraw()

## Radius for rounded outer corners
@export var corner_radius: float = 1.0:
	set(value):
		corner_radius = value
		queue_redraw()

## Color of the wall lines
@export var wall_color: Color = Color(0.85, 0.85, 0.85, 1.0):
	set(value):
		wall_color = value
		queue_redraw()

## Thickness of collision shapes (wider than visual to prevent clipping)
@export var collision_thickness: float = 16.0

func _ready() -> void:
	# Only create collisions at runtime, not in the editor
	if not Engine.is_editor_hint():
		_rebuild_collisions()

func _draw() -> void:
	var hw := frame_size.x / 2.0  # half width
	var hh := frame_size.y / 2.0  # half height
	var t := line_thickness
	var r := corner_radius
	var ht := t / 2.0  # half thickness — draw_line draws centered on the line

	# Midline of each wall (inset by half the line thickness)
	var left := -hw + ht
	var right := hw - ht
	var top := -hh + ht
	var bottom := hh - ht

	# Straight wall segments (shortened by corner radius on each end)
	draw_line(Vector2(left + r, top), Vector2(right - r, top), wall_color, t)
	draw_line(Vector2(left + r, bottom), Vector2(right - r, bottom), wall_color, t)
	draw_line(Vector2(left, top + r), Vector2(left, bottom - r), wall_color, t)
	draw_line(Vector2(right, top + r), Vector2(right, bottom - r), wall_color, t)

	# Rounded corners (arcs with matching line thickness)
	var segments := 16  # segments per arc — 16 is smooth enough for small radii
	draw_arc(Vector2(left + r, top + r), r, PI, 1.5 * PI, segments, wall_color, t)
	draw_arc(Vector2(right - r, top + r), r, 1.5 * PI, 2.0 * PI, segments, wall_color, t)
	draw_arc(Vector2(right - r, bottom - r), r, 0, 0.5 * PI, segments, wall_color, t)
	draw_arc(Vector2(left + r, bottom - r), r, 0.5 * PI, PI, segments, wall_color, t)

## Creates 4 StaticBody2D children with collision shapes at runtime
func _rebuild_collisions() -> void:
	for child in get_children():
		if child is StaticBody2D:
			child.queue_free()

	var hw := frame_size.x / 2.0
	var hh := frame_size.y / 2.0
	var ct := collision_thickness

	# [Name, Position, Shape size]
	var walls := [
		["WallLeft",   Vector2(-hw + ct / 2.0, 0),  Vector2(ct, frame_size.y)],
		["WallRight",  Vector2(hw - ct / 2.0, 0),   Vector2(ct, frame_size.y)],
		["WallTop",    Vector2(0, -hh + ct / 2.0),   Vector2(frame_size.x, ct)],
		["WallBottom", Vector2(0, hh - ct / 2.0),    Vector2(frame_size.x, ct)],
	]

	for wall_data in walls:
		var body := StaticBody2D.new()
		body.name = wall_data[0]
		var shape := CollisionShape2D.new()
		var rect := RectangleShape2D.new()
		rect.size = wall_data[2]
		shape.shape = rect
		body.position = wall_data[1]
		body.add_child(shape)
		add_child(body)
