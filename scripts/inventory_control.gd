extends Node

@onready var inventory: Control = get_parent()

func _ready() -> void:
	inventory.close()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		inventory.close() if inventory.is_open else inventory.open()
