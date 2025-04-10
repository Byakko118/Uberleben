extends Control
class_name CraftingUI

@export var inventory: InventoryUI
@export var input: LineEdit

var is_open: bool = false

func toggle_crafting():
	if inventory.is_open:
		is_open = not is_open
		visible = is_open

func _on_button_pressed() -> void:
	var result = CraftingManager.craft(input.text)
	if result:
		print("Successfully crafted!")
	else:
		print("Failed to craft - check your code and materials")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("accept"):
		_on_button_pressed()
