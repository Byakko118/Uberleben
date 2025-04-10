extends Node

var recipes: Dictionary = {
	InventoryManager.ItemID.PLANKS: {
		"inputs": { InventoryManager.ItemID.WOOD: 1 },
		"output_quantity": 4,
		"crafting_code": "bretter",  # This is what we'll check against
	}
}

func can_craft(item_id: InventoryManager.ItemID) -> bool:
	if not recipes.has(item_id):
		return false
	
	for required_id in recipes[item_id]["inputs"]:
		if not InventoryManager.has_item(required_id, recipes[item_id]["inputs"][required_id]):
			return false
	return true

func craft(crafting_code: String) -> bool:
	# Convert input to lowercase for case-insensitive matching
	crafting_code = crafting_code.to_lower()
	
	# Find matching recipe
	for item_id in recipes:
		# Check against "crafting_code" (not "code")
		if crafting_code == recipes[item_id].get("crafting_code", "").to_lower():
			if can_craft(item_id):
				# Deduct required items
				for required_id in recipes[item_id]["inputs"]:
					var amount_needed = recipes[item_id]["inputs"][required_id]
					InventoryManager.modify_item_quantity(required_id, -amount_needed)
				
				# Add crafted item
				var output_amount = recipes[item_id].get("output_quantity", 1)
				InventoryManager.modify_item_quantity(item_id, output_amount)
				return true
	
	return false
