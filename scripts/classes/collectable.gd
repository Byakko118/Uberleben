extends RigidBody2D

class_name Collectable

@export var item_name: String
var icon: CompressedTexture2D

func _ready():
	var children = get_children()
	for child in children:
		if child is Area2D:
			child.connect("body_entered",_on_body_entered)
			continue
		if child is Sprite2D:
			icon = child.texture

func _on_body_entered(body: Node2D):
	queue_free()
