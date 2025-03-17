extends Node

@onready var inventory_container: VBoxContainer = $Panel/ScrollContainer/MarginContainer/SlotContainer  # Reference to the VBoxContainer

# Preload the SlotScript to avoid the "Could not find type" error
var SlotScript = preload("res://scripts/slot.gd")  # Path to your SlotScript

# Call this when you want to initialize the inventory slots
func initialize_inventory() -> void:
	# Clear existing slots
	inventory_container.clear_children()
	
	# Loop through the inventory and create slots
	for item_name in PlayerInventory.inventory_items.keys():
		var item_data = PlayerInventory.inventory_items[item_name]
		_create_inventory_slot(item_name, item_data["icon"], item_data["quantity"])

# Creates a slot in the container
func _create_inventory_slot(item_name: String, icon: Texture, amount: int) -> void:
	var slot = SlotScript.new()  # Create a new instance of SlotScript
	inventory_container.add_child(slot)
	slot.change(item_name, icon, amount)

# Call this method to update a specific item in the inventory and slot
func update_inventory_item(item_name: String, quantity: int) -> void:
	if PlayerInventory.inventory_items.has(item_name):
		PlayerInventory.inventory_items[item_name]["quantity"] = quantity
		_update_inventory_slot(item_name)

# Updates the slot after a change
func _update_inventory_slot(item_name: String) -> void:
	# Find the slot based on item_name (or use a reference if you have one)
	for slot in inventory_container.get_children():
		if slot is SlotScript:
			if slot.item_name == item_name:
				slot.change(item_name, PlayerInventory.inventory_items[item_name]["icon"], PlayerInventory.inventory_items[item_name]["quantity"])
