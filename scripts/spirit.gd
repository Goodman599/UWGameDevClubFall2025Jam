# Requires a reference to the LevelTileMap to work
class_name Spirit
extends ControllableCharacter


var overlay_scene = preload("res://scenes/fading_text.tscn")

# Mirrors and checks the legitimacy of the player move
# Returns the mirrored move on success
# Returns 0, 0 on fail
func mirror_move(player_dir: Vector2i, potion_status) -> Vector2i:
	var move_dir: Vector2i = -player_dir
	var target_tile_position: Vector2i = tilemap.local_to_map(tilemap.to_local(global_position)) + move_dir
	if check_tile_walkability(target_tile_position, potion_status) and potion_status != 2:
		
		#print("target tile position: " + str(target_tile_position))
		# reach here if destination tile is walkable
				# reach here if destination tile is walkable
		if potion_status == 3:
			# reach here if walking distance is 2
			var target_tile_mid_path: Vector2i = tilemap.local_to_map(tilemap.to_local(global_position)) + move_dir / 2
			if check_tile_walkability(target_tile_mid_path, potion_status):
				#reach here if path is clear
				return move_dir
			else:
				spawn_overlay()
				return Vector2i(0, 0)
		else:
			return move_dir
	elif potion_status != 2:
		print("test")
		spawn_overlay()
	return Vector2i(0, 0)

func spawn_overlay() -> void:
	$FadingText.fade_out()
