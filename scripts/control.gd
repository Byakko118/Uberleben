extends Node

@export var speed := 300.0
@export var acceleration := 2000.0
@export var friction := 2000.0
@export var jump_velocity := -500.0
@export var air_control_factor := 0.5  # Reduced control in air

var parent: CharacterBody2D

func _ready():
	parent = get_parent()
	assert(parent is CharacterBody2D, "Parent must be a CharacterBody2D")

func _physics_process(delta: float) -> void:
	handle_jump()
	handle_movement(delta)
	parent.move_and_slide()

func handle_jump():
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		parent.velocity.y = jump_velocity

func handle_movement(delta: float):
	var direction = Input.get_axis("left", "right")
	var target_velocity = direction * speed
	
	if parent.is_on_floor():
		apply_acceleration(delta, target_velocity)
	else:
		apply_air_control(delta, target_velocity)

func apply_acceleration(delta: float, target_velocity: float):
	if target_velocity != 0:
		parent.velocity.x = move_toward(parent.velocity.x, target_velocity, acceleration * delta)
	else:
		parent.velocity.x = move_toward(parent.velocity.x, 0, friction * delta)

func apply_air_control(delta: float, target_velocity: float):
	if target_velocity != 0:
		# Reduced control while in the air
		parent.velocity.x = move_toward(
			parent.velocity.x, 
			target_velocity, 
			acceleration * air_control_factor * delta
		)
