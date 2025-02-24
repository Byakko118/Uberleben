extends Node2D

@export var parent_node: CharacterBody2D

func _physics_process(delta: float) -> void:
	if not parent_node.is_on_floor():
		parent_node.velocity += parent_node.get_gravity() * delta
