extends Node2D

@export var parent_node: CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -500.0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and parent_node.is_on_floor():
		parent_node.velocity.y = jump_velocity

	var direction := Input.get_axis("left", "right")
	if direction:
		parent_node.velocity.x = direction * speed
	else:
		parent_node.velocity.x = move_toward(parent_node.velocity.x, 0, speed)
	
	parent_node.move_and_slide()
