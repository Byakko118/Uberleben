extends PanelContainer
class_name InventoryUI

@onready var is_open: bool

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		toggle()

func _ready():
	is_open = false
	visible = false
	
func toggle():
	is_open = not is_open
	visible = is_open
