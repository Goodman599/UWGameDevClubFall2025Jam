# Requires a reference to the LevelTileMap to work
class_name Spirit
extends ControllableCharacter

# Mirrors and checks the legitimacy of the player move
# Returns the mirrored move on success
# Returns 0, 0 on fail
func mirror_move(player_dir: Vector2i, potion_status) -> Vector2i:
	var move_dir: Vector2i = -player_dir
	var target_tile_position: Vector2i = tilemap.local_to_map(tilemap.to_local(global_position)) + move_dir
	if check_tile_walkability(target_tile_position, potion_status) and potion_status != 2:
		
		#print("target tile position: " + str(target_tile_position))
		# reach here if destination tile is walkable
		if potion_status == 3:
			# reach here if walking distance is 2
			var target_tile_mid_path: Vector2i = tilemap.local_to_map(tilemap.to_local(global_position)) + move_dir / 2
			if check_tile_walkability(target_tile_mid_path, potion_status):
				#reach here if path is clear
				return move_dir
			else:
				return Vector2i(0, 0)
		else:
			return move_dir
	else:
		return Vector2i(0, 0)
