extends TileMapLayer


func _ready():
	destroy(Vector2i(3, 1))


enum CustomDataLayers {
	IS_WALL,
	IS_DESTRUCTABLE,
}

# Important in built functions:
#	local_to_map() & map_to_local() converts local coordinates to/from cell coordinates

func get_tile_property(tile_position: Vector2i, data_id : int):
	return get_cell_tile_data(tile_position).get_custom_data_by_layer_id(data_id)


func destroy(tile_position : Vector2i) -> bool:
	if !get_cell_tile_data(tile_position).get_custom_data_by_layer_id(CustomDataLayers.IS_DESTRUCTABLE):
		return false
	set_cell(tile_position, 0, Vector2i(4, 4))
	return true
