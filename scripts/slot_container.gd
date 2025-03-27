extends VBoxContainer

var slot_scene: PackedScene = preload("res://scenes/ui/inventory_slot.tscn")

func _ready() -> void:
	var items = PlayerInventory.inventory_items
	for item_name in items.keys():
		var item = items[item_name]
		var quantity = item["quantity"]
		if quantity <= 0:
			print("quantity is ", quantity)
			continue
		var icon = item["icon"]
		var slot = slot_scene.instantiate()
		slot.item_name = item_name
		slot.icon = icon
		slot.amount = quantity
		add_child(slot)
