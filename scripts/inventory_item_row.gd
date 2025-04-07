extends Panel
class_name InventorySlot

@export var name_label: RichTextLabel
@export var amount_label: RichTextLabel
@export var item_icon: TextureRect

var item_id: int = -1:
	set(new_id):
		if new_id != item_id:
			item_id = new_id
			_refresh_ui()

func setup(initial_item_id: int) -> void:
	item_id = initial_item_id

func _ready():
	InventoryManager.inventory_updated.connect(_on_inventory_updated)

func _refresh_ui() -> void:
	if item_id == -1 || !InventoryManager.has_item(item_id):
		_delete_slot()
		return
	
	name_label.text = InventoryManager.get_item_name(item_id)
	amount_label.text = str(InventoryManager.get_item_quantity(item_id))
	item_icon.texture = InventoryManager.get_item_texture(item_id)

func _on_inventory_updated(changed_item_id: int, new_quantity: int) -> void:
	if changed_item_id == item_id:
		if new_quantity <= 0:
			_delete_slot()
		else:
			_refresh_ui()

func _delete_slot() -> void:
	item_id = -1
	queue_free()


func _on_select_pressed() -> void:
	InventoryManager.set_selected_item(item_id)
