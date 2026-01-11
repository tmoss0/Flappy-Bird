extends Node2D

@onready var wall_spawner = %WallSpawner
var wall_scene = preload("res://level/walls.tscn")
var spawn_timer := 0.0
@export var spawn_interval := 2.0

func _process(delta: float) -> void:
	spawn_timer += delta
	if(spawn_timer > spawn_interval):
		print("Spawning wall")
		spawn_wall()
		spawn_timer = 0.0
		
func spawn_wall() -> void:
	print("Wall spawned")
	var wall = wall_scene.instantiate()
	wall.position = wall_spawner.position
	add_child(wall)
	print("Wall added at ", wall.position)
