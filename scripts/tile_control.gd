extends Node2D

# --- Constants & Exports ---
const REACH_RANGE: float = 100.0

# --- References ---
@onready var tile_map: TileMapLayer = $"../../MainTileset"
@onready var player: CharacterBody2D = get_parent()

# --- Initialization ---
func _ready() -> void:
	assert(player, "Parent node (player) must exist")
	assert(tile_map, "TileMap is not assigned")

# --- Tile Interaction Logic ---
func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	
	var mouse_tile := get_tile_under_mouse()
	var is_out_of_reach := get_distance_to_mouse() > REACH_RANGE
	
	if Input.is_action_just_pressed("action1") and not is_out_of_reach:
		try_break_tile(mouse_tile)
	
	elif Input.is_action_just_pressed("action2") and not is_out_of_reach:
		try_place_tile(mouse_tile)

# --- Tile Helpers ---
func get_tile_under_mouse() -> Vector2i:
	var mouse_pos := get_global_mouse_position()
	var local_mouse_pos := tile_map.to_local(mouse_pos)
	return tile_map.local_to_map(local_mouse_pos)

func get_distance_to_mouse() -> float:
	return player.global_position.distance_to(get_global_mouse_position())

func is_tile_occupied(tile: Vector2i) -> bool:
	return tile_map.get_cell_source_id(tile) != -1

func has_adjacent_tiles(tile: Vector2i) -> bool:
	for neighbor in tile_map.get_surrounding_cells(tile):
		if is_tile_occupied(neighbor):
			return true
	return false

func is_player_standing_on_tile(tile: Vector2i) -> bool:
	var player_tile := tile_map.local_to_map(player.position)
	return player_tile == tile

# --- Action Handlers ---
func try_break_tile(tile: Vector2i) -> void:
	var broken_tile_id := tile_map.get_cell_source_id(tile)
	tile_map.erase_cell(tile)
	drop_item_for_tile(broken_tile_id, tile)

func drop_item_for_tile(tile_id: int, tile_position: Vector2i) -> void:
	var item_id: InventoryManager.ItemID = convert_tile_id_to_item_id(tile_id)
	if item_id != InventoryManager.ItemID.EMPTY:
		spawn_item_in_world(item_id, tile_position)
		pass

func convert_tile_id_to_item_id(tile_id: int) -> InventoryManager.ItemID:
	for item_id in InventoryManager.ItemID.values():
		if item_id == tile_id and InventoryManager.drops_itself(item_id):
			return item_id
	return InventoryManager.ItemID.EMPTY

func try_place_tile(tile: Vector2i) -> void:
	var can_place := (
		not is_player_standing_on_tile(tile)
		and not is_tile_occupied(tile)
		and has_adjacent_tiles(tile)
		and InventoryManager.is_selected_item_placable()
	)
	
	if can_place:
		var selected_item = InventoryManager.get_selected_item()
		tile_map.set_cell(tile, selected_item, Vector2i.ZERO)
		InventoryManager.modify_item_quantity(selected_item, -1)

func spawn_item_in_world(item_id: InventoryManager.ItemID, tile_position: Vector2i) -> void:
	var tile_local_pos: Vector2 = tile_map.map_to_local(tile_position)
	
	var tile_center_global: Vector2 = tile_map.to_global(tile_local_pos)

	# Create item instance
	var item_scene: PackedScene = load("res://scenes/bases/item_base.tscn")
	var item: ItemBase = item_scene.instantiate()

	# Get the enum name as string (e.g., "DIRT", "STONE")
	var enum_name: String = InventoryManager.ItemID.keys()[item_id + 1]
	
	# Load matching resource using the enum name directly
	var resource_path := "res://resources/custom_resources/%s.tres" % enum_name.to_lower()
	if ResourceLoader.exists(resource_path):
		item.item_stats = load(resource_path)
	else:
		push_error("Resource not found: ", resource_path)
		item.queue_free()
		return

	# Position and add to scene
	item.global_position = tile_center_global
	get_tree().current_scene.add_child(item)
	
	# Apply impulse away from player
	if item is RigidBody2D:
		var direction = (item.global_position - player.global_position).normalized()
		var impulse_strength = 150  # Adjust this value for more/less force
		var random_variation = Vector2(randf_range(-0.3, 0.3), randf_range(-0.3, 0.3))  # Small random variation
		var final_direction = (direction + random_variation).normalized()
		
		item.apply_central_impulse(final_direction * impulse_strength)
		item.apply_torque_impulse(randf_range(-50, 50))  # Optional: add some spin
