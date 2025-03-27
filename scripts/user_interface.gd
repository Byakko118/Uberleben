extends Control

var inventory_open: bool = false

var inventory_scene: PackedScene = preload("res://scenes/ui/inventory.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		if not inventory_open:
			var inventory_instance = inventory_scene.instantiate()
			add_child(inventory_instance)
			inventory_instance.name = "Inventory"
			inventory_open = true
			print(inventory_open)
		else:
			for child in get_children():
				if child.name == "Inventory":
					child.queue_free()
					inventory_open = false
					print(inventory_open)
