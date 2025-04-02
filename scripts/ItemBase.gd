@tool  # Show in editor
class_name ItemBase
extends Area2D  # or Area3D

@export var item_data: ItemData:
	set(new_data):
		item_data = new_data
		_update_appearance()  # Auto-update sprite when data changes

func _update_appearance():
	print("xdd")
	if Engine.is_editor_hint() and item_data:  # Works in editor
		$Sprite2D.texture = item_data.texture
		print("xdd")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.pick_up_item(self)
		queue_free()
