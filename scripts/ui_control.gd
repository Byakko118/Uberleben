extends Node2D

@onready var inventory: Control = get_node("../../CanvasLayer/Ui/InventoryUI")

func _ready():
	if not inventory:
		push_error("Inventory node not found! Check path: /root/Main/CanvasLayer/Inventory")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		inventory.toggle_inventory()
