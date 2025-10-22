class_name LevelTileMap
extends TileMapLayer


enum CustomDataLayers {
	IS_WALKABLE,
	IS_DESTRUCTABLE,
}

var marked_for_destruction : Vector2i

# Important in built functions:
#	local_to_map() & map_to_local() converts local coordinates to/from cell coordinates

# Given a tile position, and a property (Can be found using enumerator)
# Returns the value for the custom data (transformative)
func get_tile_property(tile_position: Vector2i, data_id : int):
	if get_cell_tile_data(tile_position) == null:
		return null
	
	if data_id == CustomDataLayers.IS_DESTRUCTABLE:
		if $Destructables.get_cell_tile_data(tile_position) == null:
			return null
		return $Destructables.get_cell_tile_data(tile_position).get_custom_data("is_destructable")
	
	return get_cell_tile_data(tile_position).get_custom_data_by_layer_id(data_id)


# Given a tile position, and if it is breakable, turns it into a normal path.
func destroy(tile_position : Vector2i):
	if $Destructables.get_cell_tile_data(tile_position) != null and $Destructables.get_cell_tile_data(tile_position).get_custom_data("is_destructable"):
		# Change target tile into a broken block
		$Destructables.set_cell(tile_position, 0, Vector2(1, 0))

func mark_for_destruction(tile : Vector2i):
	marked_for_destruction = tile
	
func destroy_marked_tile():
	if marked_for_destruction:
		destroy(marked_for_destruction)

func clear_marked_tile():
	# This is gonna bite us in the ass one day
	marked_for_destruction = Vector2i(-1000, -1000)
