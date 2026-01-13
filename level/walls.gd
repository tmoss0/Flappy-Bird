extends Node2D

@export var debugging = true
@export var delete_wall_position = -500
@export var wall_width := 200.0
@export var gap_size := 150.0
@export var wall_thickness := 50.0
@export var screen_height := 600.0
@export var scroll_speed := 200.0

func _ready() -> void:
	print("Wall Create Function called")
	create_wall()

func _process(delta: float) -> void:
	position.x -= scroll_speed * delta
	
	if(position.x < delete_wall_position):
		queue_free()

func create_wall() -> void:
	# Top Gap
	# Top bar + half of gap size to create top por
	
	var half_gap = gap_size / 2
	var min_gap_y = half_gap + 50
	var max_gap_y = screen_height - half_gap - 50
	var gap_center_y = randf_range(min_gap_y, max_gap_y)
	if(debugging):
		print("Half Gap: ", half_gap)
		print("Min Gap Y: ", min_gap_y)
		print("Max Gap Y: ", max_gap_y)
		print("Gap Center Y: ", gap_center_y)
	
	# Top wall section
	var top_wall = StaticBody2D.new()
	var top_collision = CollisionShape2D.new()
	var top_shape = RectangleShape2D.new()
	
	var top_height = gap_center_y - half_gap
	var top_y_position = top_height / 2
	top_shape.size = Vector2(wall_thickness, top_height)
	top_collision.shape = top_shape
	top_collision.position = Vector2(0, top_y_position)
	if(debugging):
		print("Top Height: ", top_height)
		print("Top Y Position", top_y_position)
	
	top_wall.add_child(top_collision)
	add_child(top_wall)
	
	# Bottom wall section
	var bottom_wall = StaticBody2D.new()
	var bottom_collision = CollisionShape2D.new()
	var bottom_shape = RectangleShape2D.new()
	
	var bottom_start_y = gap_center_y + half_gap
	var bottom_height = screen_height - bottom_start_y
	var bottom_y_position = bottom_start_y + (bottom_height / 2)
	bottom_shape.size = Vector2(wall_thickness, bottom_height)
	bottom_collision.shape = bottom_shape
	bottom_collision.position = Vector2(0, bottom_y_position)
	if(debugging):
		print("Top Height: ", bottom_start_y)
		print("Top Y Position", bottom_height)
		print("Bottom Position Y", bottom_y_position)
	
	bottom_wall.add_child(bottom_collision)
	add_child(bottom_wall)
	
	add_visual(top_wall, Vector2(wall_thickness, top_height), Vector2(0, top_height))
	add_visual(bottom_wall, Vector2(wall_thickness, bottom_height), Vector2(0, bottom_height))
	
func add_visual(parent: Node2D, size: Vector2, pos: Vector2) -> void:
	var visual = ColorRect.new()
	visual.size = size
	visual.position = pos - (size / 2)
	visual.color = Color.RED
	parent.add_child(visual)
	
