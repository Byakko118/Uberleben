extends Control
class_name InventoryUI

@export var slot_scene: PackedScene
@export var slots_container: Container

var slots: Array[InventorySlot] = []
var is_open: bool = false

func _ready():
	# Connect signal first
	InventoryManager.inventory_updated.connect(_on_inventory_updated)
	# Initial setup
	refresh_inventory()
	# Ensure game isn't paused when starting
	get_tree().paused = false

func _on_inventory_updated(_item_id: int, _quantity: int):
	refresh_inventory()

func refresh_inventory():
	_clear_all_slots()
	_create_initial_slots()

func _clear_all_slots():
	for slot in slots:
		slot.queue_free()
	slots.clear()

func _create_initial_slots():
	for item_id in InventoryManager.get_all_items():
		_create_slot(item_id)

func _create_slot(item_id: int):
	var slot = slot_scene.instantiate()
	slots_container.add_child(slot)
	slot.setup(item_id)  # Use setup() to initialize
	slots.append(slot)

func toggle_inventory():
	is_open = not is_open
	visible = is_open
	# Pause the game when inventory is open, unpause when closed
	get_tree().paused = is_open
