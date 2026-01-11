extends CharacterBody2D

@export var SPEED := 300.0
@export var JUMP_VELOCITY := -400.0
@export var JUMP_COOLDOWN := 0.6

var jump_timer := 0.0

func _physics_process(delta: float) -> void:
	if jump_timer > 0:
		jump_timer -= delta
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and jump_timer <= 0:
		velocity.y = JUMP_VELOCITY
		jump_timer = JUMP_COOLDOWN
		print("JUMP")

	move_and_slide()

func _on_platform_body_entered(body: Node2D) -> void:
	if(body.name == "Character"): 
		print("Game over!")
