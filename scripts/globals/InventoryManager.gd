extends Node

signal inventory_updated(item_id: ItemID, new_quantity: int)
signal selection_changed(new_selection: ItemID)  # Emit when selection changes

enum ItemID { EMPTY = -1, DIRT = 0, STONE, SAND, WOOD, PLANKS, IRON, COAL, RUBY, DIAMOND, COPPER }

# Initialize with starting quantities
var items: Dictionary = {
	ItemID.EMPTY: { "name": "Empty",  "quantity": 0, "is_placable": false, "drops_itself": false },
	ItemID.DIRT:  { "name": "Erde",  "quantity": 5, "is_placable": true, "drops_itself": true },
	ItemID.STONE: { "name": "Stein", "quantity": 12, "is_placable": true, "drops_itself": true },
	ItemID.SAND:  { "name": "Sand",  "quantity": 2, "is_placable": true, "drops_itself": true },
	ItemID.PLANKS:  { "name": "Bretter",  "quantity": 2, "is_placable": true, "drops_itself": true },
	ItemID.WOOD:  { "name": "Holz",  "quantity": 2, "is_placable": true, "drops_itself": true },
	ItemID.IRON:  { "name": "Eisen",  "quantity": 2, "is_placable": false, "drops_itself": true },
	ItemID.COAL:  { "name": "Kohle",  "quantity": 2, "is_placable": false, "drops_itself": true },
	ItemID.RUBY:  { "name": "Rubin",  "quantity": 2, "is_placable": false, "drops_itself": true },
	ItemID.DIAMOND:  { "name": "Diamant",  "quantity": 2, "is_placable": false, "drops_itself": true },
	ItemID.COPPER:  { "name": "Kupfer",  "quantity": 2, "is_placable": false, "drops_itself": true },
}

var selected_item: ItemID = ItemID.EMPTY  # Default selection (could also be null)

const ITEM_TEXTURES = {
	ItemID.DIRT:  preload("res://resources/item_sprites/Dirt.png"),
	ItemID.STONE: preload("res://resources/item_sprites/Stone.png"),
	ItemID.SAND:  preload("res://resources/item_sprites/Sand.png"),
	ItemID.PLANKS:  preload("res://resources/item_sprites/Planks.png"),
	ItemID.WOOD:  preload("res://resources/item_sprites/Wood.png"),
	ItemID.IRON:  preload("res://resources/item_sprites/iron.png"),
	ItemID.COAL:  preload("res://resources/item_sprites/coal.png"),
	ItemID.RUBY:  preload("res://resources/item_sprites/ruby.png"),
	ItemID.DIAMOND:  preload("res://resources/item_sprites/diamond.png"),
	ItemID.COPPER: preload("res://resources/item_sprites/copper.png")
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
		set_selected_item(ItemID.EMPTY)

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

func is_selected_item_placable() -> bool:
	if not has_selected_item():
		return false
	return items.get(get_selected_item(), {}).get("is_placable", false)

func drops_itself(item_id: ItemID) -> bool:
	return items.get(item_id, {}).get("drops_itself")
