extends Node2D

var tile_map: TileMapLayer

var _parent: CharacterBody2D
var block_equipped = 3
var reach_range = 250

func _ready():
	tile_map = $"../../TestingGround"
	_parent = get_parent()
	assert(_parent, "Parent node must exist")
	assert(tile_map, "TileMap is not assigned")

func is_player_in_tile(tilemap: TileMapLayer, player_position: Vector2, target_coords: Vector2i) -> bool:
	var player_tile_coords = tilemap.local_to_map(player_position)
	return player_tile_coords == target_coords
	
func tile_exists_at(tilemap: TileMapLayer, coords: Vector2i):
	return tilemap.get_cell_source_id(coords) != -1
	
func tile_has_surrounding_tiles(tilemap: TileMapLayer, coords: Vector2i):
	var neighbours = tilemap.get_surrounding_cells(coords)
	for tile in neighbours:
		if tilemap.get_cell_source_id(tile) != -1:
			return true
	return false

func get_player_distance_from_mouse():
	var pos = _parent.global_position - get_global_mouse_position()
	var distance = pos.length()
	return distance

func get_tile_from_mouse_position():
	var mouse_pos = get_global_mouse_position()
	var local_mouse_pos = tile_map.to_local(mouse_pos)
	return tile_map.local_to_map(local_mouse_pos)

func _input(event):
	if Input.is_action_just_pressed("action1"):
		if get_player_distance_from_mouse() > reach_range:
			return
		tile_map.erase_cell(get_tile_from_mouse_position())
		
	if Input.is_action_just_pressed("action2"):
		var tile = get_tile_from_mouse_position()
		if is_player_in_tile(tile_map, _parent.position, tile) or tile_exists_at(tile_map, tile) or !tile_has_surrounding_tiles(tile_map, tile) or get_player_distance_from_mouse() > reach_range:
			return
		tile_map.set_cell(tile, block_equipped, Vector2i(0,0))
		
