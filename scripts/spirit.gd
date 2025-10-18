# Requires a reference to the LevelTileMap to work
class_name Spirit
extends ControllableCharacter

# Mirrors and checks the legitimacy of the player move
# Returns the mirrored move on success
# Returns 0, 0 on fail
func mirror_move(player_dir: Vector2i) -> Vector2i:
	var move_dir: Vector2i = -player_dir
	var target_tile_position: Vector2i = tilemap.local_to_map(tilemap.to_local(global_position)) + move_dir
	
	if check_tile_walkability(target_tile_position):
		return move_dir
	else:
		return Vector2i(0, 0)
