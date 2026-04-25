extends Node2D

## Panel and buttons live in [PackedScene] res://level/game_over.tscn — instanced as child GameOver.
@onready var wall_spawner = %WallSpawner
@onready var game_over_ui = $GameOver
@onready var score_label: Label = %ScoreLabel
var wall_scene = preload("res://level/walls.tscn")
var spawn_timer: float = 0.0
@export var spawn_interval: float = 2.0
var _game_over: bool = false
var score: int = 0

func _ready() -> void:
	_refresh_score_label()

func _process(delta: float) -> void:
	if _game_over:
		return
	spawn_timer += delta
	if (spawn_timer > spawn_interval):
		print("Spawning wall")
		spawn_wall()
		spawn_timer = 0.0
		
func spawn_wall() -> void:
	print("Wall spawned")
	var wall = wall_scene.instantiate()
	wall.position = wall_spawner.position
	wall.wall_hit.connect(_on_wall_hit)
	wall.scored.connect(_on_wall_scored)
	
	add_child(wall)
	print("Wall added at ", wall.position)

func _on_wall_scored() -> void:
	if _game_over:
		return
	score += 1
	_refresh_score_label()

func _refresh_score_label() -> void:
	score_label.text = "Score: %d" % score

func _on_wall_hit() -> void:
	_end_game()

func _on_platform_body_entered(body: Node2D) -> void:
	if body.name != "Character":
		return
	_end_game()

func _end_game() -> void:
	if _game_over:
		return
	_game_over = true
	game_over_ui.show_game_over(score)
	get_tree().paused = true
