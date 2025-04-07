@tool
extends Resource
class_name ItemStats

@export var id: InventoryManager.ItemID = InventoryManager.ItemID.EMPTY:
	set(new_id):
		id = new_id
		emit_changed()
		
@export var texture: Texture2D:
	set(new_textrue):
		texture = new_textrue
		emit_changed()
