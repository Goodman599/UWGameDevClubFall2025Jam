extends TileMapLayer


enum CustomDataLayers {
	IS_WALL,
}

# Important in built functions:
#	local_to_map() & map_to_local() converts local coordinates to/from cell coordinates

func get_tile_property(tile_position: Vector2i, data_id : int):
	return get_cell_tile_data(tile_position).get_custom_data_by_layer_id(data_id)
