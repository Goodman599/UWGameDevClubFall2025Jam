extends TileMapLayer

@export var character: CharacterBody2D
@export var spirit: CharacterBody2D

enum CustomDataLayers {
	IS_WALKABLE,
	IS_WALL,
	IS_DESTRUCTABLE,
}

func _ready():
	set_entity_positions()
	if character and spirit:
		character.movement_finished.connect(check_victory)
		spirit.movement_finished.connect(check_victory)

func set_entity_positions():
	if character:
		var character_grid_pos = Vector2i(0, 0)
		character.global_position = map_to_local(character_grid_pos)
		character.tile_map = self
		character.spirit = spirit
	
	if spirit:
		var spirit_grid_pos = Vector2i(16, 10)
		spirit.global_position = map_to_local(spirit_grid_pos)
		spirit.character = character

func check_victory():
	if character and spirit:
		var character_tile = local_to_map(character.global_position)
		var spirit_tile = local_to_map(spirit.global_position)
		
		if character_tile == spirit_tile:
			print("Congrats!")
			victory()

func victory():
	get_tree().paused = true

#For testing spawn method

# Important in built functions:
#	local_to_map() & map_to_local() converts local coordinates to/from cell coordinates

# Given a tile position, and a property (Can be found using enumerator)
# Returns the value for the custom data (transformative)
func get_tile_property(tile_position: Vector2i, data_id : int):
	return get_cell_tile_data(tile_position).get_custom_data_by_layer_id(data_id)

func is_walkable(tile_position: Vector2i) -> bool:
	return get_tile_property(tile_position, CustomDataLayers.IS_WALKABLE)

func is_wall(tile_position: Vector2i) -> bool:
	return get_tile_property(tile_position, CustomDataLayers.IS_WALL)

# Given a tile position, and if it is breakable, turns it into a normal path.
func destroy(tile_position : Vector2i):
	if get_cell_tile_data(tile_position).get_custom_data_by_layer_id(CustomDataLayers.IS_DESTRUCTABLE):
		# Change target tile into a path terrain
		set_cells_terrain_connect([tile_position], 0, 0)
