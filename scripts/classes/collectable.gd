extends RigidBody2D
class_name Collectable

@export var item_name: String
var icon: CompressedTexture2D

signal item_created
signal item_added

func add_to_inventory():
	if not PlayerInventory:
		print("PlayerInventory is not accessible.")
		return
	if item_name in PlayerInventory.inventory_items:
		PlayerInventory.inventory_items[item_name]["quantity"] += 1
		emit_signal("item_added")
	else:
		PlayerInventory.inventory_items[item_name] = {
			"quantity": 1,
			"icon": icon
		}
		emit_signal("item_created")

func _ready():
	var children = get_children()
	for child in children:
		if child is Area2D:
			child.connect("body_entered", _on_body_entered)
			continue
		if child is Sprite2D:
			icon = child.texture

func _on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		add_to_inventory()
		print(PlayerInventory.inventory_items)
		queue_free() 
