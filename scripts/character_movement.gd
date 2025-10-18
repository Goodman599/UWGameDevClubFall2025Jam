extends CharacterBody2D

@export var tile_map: TileMapLayer
@export var spirit: CharacterBody2D

const tile_size: Vector2 = Vector2(64, 64)
var sprite_node_pos_tween : Tween

signal player_moved(direction: Vector2)
signal movement_finished

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		_try_move(Vector2(0,-1))
	if Input.is_action_just_pressed("ui_down"):
		_try_move(Vector2(0,1))
	if Input.is_action_just_pressed("ui_left"):
		_try_move(Vector2(-1,0))
	if Input.is_action_just_pressed("ui_right"):
		_try_move(Vector2(1,0))

func _move(dir: Vector2):
	global_position += dir * tile_size
	$Sprite2D.global_position -= dir * tile_size
	
	player_moved.emit(dir)
	
	if sprite_node_pos_tween:
		sprite_node_pos_tween.kill()
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property($Sprite2D, "global_position", global_position, 0.185).set_trans(Tween.TRANS_SINE)
	
	sprite_node_pos_tween.finished.connect(_on_tween_finished, CONNECT_ONE_SHOT)

func _try_move(dir: Vector2):
	if not tile_map or not spirit:
		return
	
	var next_pos = global_position + dir * tile_size
	var next_tile = tile_map.local_to_map(next_pos)
	
	var mirror_dir = -dir
	var spirit_next_pos = spirit.global_position + mirror_dir * tile_size
	var spirit_next_tile = tile_map.local_to_map(spirit_next_pos)
	
	var character_can_move = tile_map.is_walkable(next_tile)
	var spirit_can_move = tile_map.is_walkable(spirit_next_tile)
	
	if character_can_move and spirit_can_move:
		_move(dir)

func _on_tween_finished():
	movement_finished.emit()
