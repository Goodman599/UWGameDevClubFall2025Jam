class_name ControllableCharacter
extends Node2D

signal movement_completed

const TILE_SIZE = Vector2(128, 128)

@export var tilemap : LevelTileMap
@onready var movement_tween : Tween

var can_move : bool = true

# Tweens movement
func move(int_dir: Vector2i):
	tilemap.destroy_marked_tile()
	var dir = Vector2(int_dir)

	movement_tween = get_tree().root.create_tween()
	movement_tween.set_trans(Tween.TRANS_SINE)
	movement_tween.tween_property(self, "global_position", global_position + dir * TILE_SIZE, 0.185)
	
	await movement_tween.finished
	
	emit_signal("movement_completed")


func check_tile_walkability(tile_position: Vector2i, potion_status : int):
	# Can add additional conditions, such as "target is destructable && has destruction potion effect"
	if tilemap.get_tile_property(tile_position, tilemap.CustomDataLayers.IS_DESTRUCTABLE):
		if tile_position == tilemap.marked_for_destruction: # If a spirit has marked this tile as destruction
			return true
		
		if self.name != "Spirit": # I hate checking for name but this is the simplest way
			return false # Only the spirit can have the potion effect
		
		# If the spirit can destroy a tile, mark it for destruction	
		if (potion_status == 1):
			tilemap.mark_for_destruction(tile_position)
		return potion_status == 1
		
	return tilemap.get_tile_property(tile_position, tilemap.CustomDataLayers.IS_WALKABLE)
