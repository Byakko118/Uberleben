extends PanelContainer

var icon: CompressedTexture2D : 
	set(icon): 
		print("Setting icon to:", icon)
		$MarginContainer/PanelContainer2/AspectRatioContainer/PanelContainer/TextureRect.texture = icon

var item_name: String :
	set(item_name): 
		print("Setting item name to:", item_name)
		$MarginContainer/PanelContainer2/VBoxContainer/NameLabel.text = item_name

var amount: int :
	set(amount): 
		print("Setting amount to:", amount)
		$MarginContainer/PanelContainer2/VBoxContainer/AmountLabel.text = str(amount)

var id: int

func _on_button_pressed() -> void:
	var items = PlayerInventory.inventory_items
	print("Button pressed!")
	for key in items.keys():
		if key == item_name:
			if PlayerInventory.inventory_items[key].quantity > 0:
				PlayerInventory.inventory_items[key].quantity -= 1
			else:
				queue_free()
		
