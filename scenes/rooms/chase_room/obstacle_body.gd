extends StaticBody2D

const OBSTACLE_COLOR := Color.BLACK

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	# Iterate all children and draw each collision shape black
	for child in get_children():
		_draw_shape(child)

func _draw_shape(node: Node) -> void:
	# Offset of the child node relative to ObstacleBody
	var offset: Vector2 = node.position if node is Node2D else Vector2.ZERO

	if node is CollisionShape2D:
		var shape = node.shape
		if shape is RectangleShape2D:
			# draw_rect expects a Rect2 centered at the shape's position
			var size: Vector2 = shape.size
			draw_rect(Rect2(offset - size / 2.0, size), OBSTACLE_COLOR)
		elif shape is CircleShape2D:
			draw_circle(offset, shape.radius, OBSTACLE_COLOR)

	elif node is CollisionPolygon2D:
		# Polygon points are local to the CollisionPolygon2D — shift by its offset
		var shifted: PackedVector2Array = []
		for point in node.polygon:
			shifted.append(point + offset)
		if shifted.size() >= 3:
			draw_polygon(shifted, PackedColorArray([OBSTACLE_COLOR]))
