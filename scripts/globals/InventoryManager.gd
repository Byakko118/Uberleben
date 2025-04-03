extends Node

signal inventory_updated(item_id: ItemID, new_quantity: int)
signal selection_changed(new_selection: ItemID)  # Emit when selection changes

enum ItemID { DIRT = 0, STONE, SAND }

# Initialize with starting quantities
var items: Dictionary = {
	ItemID.DIRT:  { "name": "dirt",  "quantity": 5 },
	ItemID.STONE: { "name": "stone", "quantity": 0 },
	ItemID.SAND:  { "name": "sand",  "quantity": 2 }
}

var selected_item: ItemID = ItemID.DIRT  # Default selection (could also be null)

const ITEM_TEXTURES = {
	ItemID.DIRT:  preload("res://resources/item_sprites/Dirt.png"),
	ItemID.STONE: preload("res://resources/item_sprites/Stone.png"),
	ItemID.SAND:  preload("res://resources/item_sprites/Sand.png")
}

### --- Item Quantity Management ---
func modify_item_quantity(item_id: ItemID, quantity: int) -> void:
	if not items.has(item_id):
		push_error("Tried to modify nonexistent item: %s" % item_id)
		return
	
	items[item_id]["quantity"] = max(items[item_id]["quantity"] + quantity, 0)
	emit_signal("inventory_updated", item_id, items[item_id]["quantity"])
	
	# If selected item runs out, auto-deselect it
	if item_id == selected_item and items[item_id]["quantity"] <= 0:
		set_selected_item(0)

### --- Selection Management ---
func set_selected_item(item_id: ItemID) -> void:
	# Only allow selecting items that exist and have quantity > 0
	if item_id != null and (not items.has(item_id) or items[item_id]["quantity"] <= 0):
		return
	
	if selected_item != item_id:
		selected_item = item_id
		emit_signal("selection_changed", selected_item)

func get_selected_item() -> ItemID:
	return selected_item

func has_selected_item() -> bool:
	return selected_item != null and items[selected_item]["quantity"] > 0

### --- Helper Methods (unchanged) ---
func get_item_name(item_id: ItemID) -> String:
	return items.get(item_id, {}).get("name", "")

func get_item_texture(item_id: ItemID) -> Texture2D:
	return ITEM_TEXTURES.get(item_id)

func has_item(item_id: ItemID, quantity: int = 1) -> bool:
	return items.get(item_id, {}).get("quantity", 0) >= quantity

func get_item_quantity(item_id: ItemID) -> int:
	return items.get(item_id, {}).get("quantity", 0)

func get_all_items() -> Array:
	var valid_items := []
	for item_id in items:
		if items[item_id]["quantity"] > 0:
			valid_items.append(item_id)
	return valid_items
