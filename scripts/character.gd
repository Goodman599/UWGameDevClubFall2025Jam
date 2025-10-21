class_name ControllableCharacter
extends Node2D

signal movement_completed

const TILE_SIZE = Vector2(64, 64)

@export var tilemap : LevelTileMap
@onready var movement_tween : Tween

var can_move : bool = true

# Tweens movement
func move(int_dir: Vector2i):
	var dir = Vector2(int_dir)

	movement_tween = get_tree().root.create_tween()
	movement_tween.set_trans(Tween.TRANS_SINE)
	movement_tween.tween_property(self, "global_position", global_position + dir * TILE_SIZE, 0.185)
	
	await movement_tween.finished
	
	emit_signal("movement_completed")


func check_tile_walkability(tile_position: Vector2i):
	# Can add additional conditions, such as "target is destructable && has destruction potion effect"
	return tilemap.get_tile_property(tile_position, tilemap.CustomDataLayers.IS_WALKABLE)
