extends Node2D

@export var tilemap_layer: TileMapLayer
@export var player: CharacterBody2D
@export var world_size: Vector2i = Vector2i(3000, 1000)
@export var default_tile: int = InventoryManager.ItemID.STONE

func _ready():
	if !tilemap_layer:
		push_error("TileMapLayer not assigned!")
		return
	
	# Generate the world instantly (for small/medium worlds)
	generate_world_instant()
	
	# Position player at world center
	if player:
		var center_x = world_size.x / 2
		var surface_y = find_surface_position(center_x)
		if surface_y != -1:
			player.global_position = Vector2(center_x, surface_y - 0)  # 20px above surface
			print("Player spawned at: ", player.global_position)
		else:
			push_error("Couldn't find surface position!")

func generate_world_instant():
	print("Generating world...")
	
	# Fill entire world with stone
	for x in world_size.x:
		for y in world_size.y:
			tilemap_layer.set_cell(Vector2i(x, y), 0, Vector2i(0, 0), 0)
	
	print("World generation complete - ", world_size.x * world_size.y, " tiles created")

func find_surface_position(x: float) -> int:
	var x_coord = int(clamp(x, 0, world_size.x-1))
	for y in range(0, world_size.y):
		if tilemap_layer.get_cell_source_id(Vector2i(x_coord, y)) != -1:
			return y
	return -1
