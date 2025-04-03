@tool
extends RigidBody2D
class_name ItemBase

@export var item_stats: ItemStats:
	set(new_item_stats):
		item_stats = new_item_stats
		if item_stats:
			item_stats.changed.connect(_on_changed)
		else:
			item_stats.changed.disconnect(_on_changed)

func _on_changed():
	$Sprite2D.texture = item_stats.texture

func _ready() -> void:
	_on_changed()


func _on_pickup_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		InventoryManager.modify_item_quantity(item_stats.id, 1)
		queue_free()
