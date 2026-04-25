extends Node2D

signal wall_hit
signal scored

@export var debugging: bool = true
@export var delete_wall_position: float = -500.0
@export var wall_width: float = 200.0
@export var gap_size: float = 150.0
@export var wall_y_bottom_position: float = -100.0
@export var wall_y_top_position: float = -500.0
@export var wall_thickness: float = 50.0
@export var screen_height: float = 600.0
@export var scroll_speed: float = 200.0
var half_gap: float = gap_size / 2

func _ready() -> void:
	print("Wall Create Function called")
	create_wall()

func _process(delta: float) -> void:
	position.x -= scroll_speed * delta
	
	if(position.x < delete_wall_position):
		queue_free()

func create_wall() -> void:
	var wall_gap_location = randf_range(wall_y_top_position, wall_y_bottom_position)
	if(debugging):
		print("Wall gap location: ", wall_gap_location)
		print("Half gap: ", half_gap)
	
	# Create bottom wall (from y=0 going up to gap start)
	var bottom_wall_top = wall_gap_location + half_gap
	var bottom_wall_height = abs(bottom_wall_top - 0)
	var bottom_wall_position = Vector2(0, bottom_wall_top / 2)
	if(debugging):
		print("Bottom wall - Height: ", bottom_wall_height, " Position: ", bottom_wall_position, " Top: ", bottom_wall_top)
	create_wall_segment(bottom_wall_height, bottom_wall_position)
	
	# Create top wall (from gap end going up to wall_y_top_position)
	var top_wall_bottom = wall_gap_location - half_gap
	var top_wall_height = abs(wall_y_top_position - top_wall_bottom)
	var top_wall_position = Vector2(0, (top_wall_bottom + wall_y_top_position) / 2)
	if(debugging):
		print("Top wall - Height: ", top_wall_height, " Position: ", top_wall_position, " Bottom: ", top_wall_bottom)
	create_wall_segment(top_wall_height, top_wall_position)
	create_score_zone(wall_gap_location)

func create_score_zone(gap_center_y: float) -> void:
	var zone := Area2D.new()
	zone.collision_layer = 0
	zone.collision_mask = 1
	var collision := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(24.0, maxf(gap_size - 4.0, 8.0))
	collision.shape = rect
	zone.add_child(collision)
	zone.position = Vector2(0.0, gap_center_y)
	zone.body_entered.connect(func(body: Node2D) -> void: _on_score_zone_body_entered(body, zone))
	add_child(zone)

func _on_score_zone_body_entered(body: Node2D, zone: Area2D) -> void:
	if body.name != "Character":
		return
	scored.emit()
	zone.queue_free()

func create_wall_segment(height: float, wall_position: Vector2) -> void:
	var wall = generate_wall()
	var size = Vector2(wall_thickness, height)
	
	# Set the wall's position
	wall.position = wall_position
	
	# Set collision shape size
	var collision = wall.get_child(0) as CollisionShape2D
	(collision.shape as RectangleShape2D).size = size
	
	wall.body_entered.connect(_on_wall_body_entered)
	if(debugging):
		print("Wall Area2D position: ", wall.global_position)
		print("Collision shape size: ", (collision.shape as RectangleShape2D).size)
	
	add_visual(wall, size)
	add_child(wall)

func generate_wall() -> Node2D:
	var wall = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	
	collision.shape = shape 
	wall.add_child(collision)
	
	wall.collision_layer = 2
	wall.collision_mask = 1
	
	if(debugging):
		print("Wall created - Layer: ", wall.collision_layer, " Mask: ", wall.collision_mask)
	
	return wall
	
func add_visual(parent: Node2D, size: Vector2, visual_position = Vector2.ZERO) -> void:
	var visual = ColorRect.new()
	visual.size = size
	visual.position = visual_position - (size / 2)
	visual.color = Color.RED
	parent.add_child(visual)
	
func _on_wall_body_entered(body: Node2D) -> void:
	if(debugging):
		print("!!! COLLISION DETECTED !!! Body: ", body.name, " Type: ", body.get_class())	
	if(body.name == "Character"):
		wall_hit.emit()
