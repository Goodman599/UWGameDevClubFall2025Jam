extends TileMapLayer


enum CustomDataLayers {
	IS_WALKABLE,
	IS_WALL,
	IS_DESTRUCTABLE,
}

# Important in built functions:
#	local_to_map() & map_to_local() converts local coordinates to/from cell coordinates

# Given a tile position, and a property (Can be found using enumerator)
# Returns the value for the custom data (transformative)
func get_tile_property(tile_position: Vector2i, data_id : int):
	return get_cell_tile_data(tile_position).get_custom_data_by_layer_id(data_id)


# Given a tile position, and if it is breakable, turns it into a normal path.
func destroy(tile_position : Vector2i):
	if get_cell_tile_data(tile_position).get_custom_data_by_layer_id(CustomDataLayers.IS_DESTRUCTABLE):
		# Change target tile into a path terrain
		set_cells_terrain_connect([tile_position], 0, 0)
