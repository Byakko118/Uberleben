extends PanelContainer
class_name Slot

var item_name: String = ""
var icon: Texture
var amount: int = 0

@onready var name_label: RichTextLabel = $MarginContainer/PanelContainer2/VBoxContainer/NameLabel
@onready var amount_label: RichTextLabel = $MarginContainer/PanelContainer2/VBoxContainer/AmountLabel
@onready var icon_texture: TextureRect = $MarginContainer/PanelContainer2/AspectRatioContainer/PanelContainer/TextureRect

func _ready() -> void:
	# Initialize the slot with default values
	update_slot()

func change(new_item_name: String, new_icon: Texture, new_amount: int) -> void:
	item_name = new_item_name
	icon = new_icon
	amount = new_amount
	update_slot()

# Update the slot UI
func update_slot() -> void:
	name_label.text = item_name
	amount_label.text = str(amount)
	icon_texture.texture = icon
