# TileDestroyer.gd
extends Node2D

@export var tile_map: TileMapLayer

var _parent: Node2D
var block_equipped = 2

func _ready():
	tile_map = $"../../TestingGround"
	_parent = get_parent()
	assert(_parent, "Parent node must exist")
	assert(tile_map, "TileMap is not assigned")

func get_tile_from_mouse_position():
		var mouse_pos = get_global_mouse_position()
		var local_mouse_pos = tile_map.to_local(mouse_pos)
		return tile_map.local_to_map(local_mouse_pos)

func _input(event):
	if Input.is_action_just_pressed("action1"):
		tile_map.erase_cell(get_tile_from_mouse_position())
		
	if Input.is_action_just_pressed("action2"):
		tile_map.set_cell(get_tile_from_mouse_position(), block_equipped, Vector2i(0,0))
		
