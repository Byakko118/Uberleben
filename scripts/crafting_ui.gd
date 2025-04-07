extends Control
class_name CraftingUI

@export var inventory: InventoryUI

var is_open: bool = false

func toggle_crafting():
	if inventory.is_open:
		is_open = not is_open
		visible = is_open

func try_craft(item: InventoryManager.ItemID):
	#TODO Pls go here do this
	pass
