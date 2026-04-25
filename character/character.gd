extends CharacterBody2D

@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -400.0
@export var JUMP_COOLDOWN: float = 0.6

var jump_timer: float = 0.0

func _physics_process(delta: float) -> void:
	if jump_timer > 0:
		jump_timer -= delta
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and jump_timer <= 0:
		velocity.y = JUMP_VELOCITY
		jump_timer = JUMP_COOLDOWN
		print("JUMP")
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print("Character colliding with: ", collision.get_collider().name)

	move_and_slide()
