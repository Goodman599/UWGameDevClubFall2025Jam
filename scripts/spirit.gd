extends CharacterBody2D

@export var character: CharacterBody2D

const tile_size: Vector2 = Vector2(16, 16)
var sprite_node_pos_tween : Tween
signal movement_finished

func _ready() -> void:
	if character:
		character.player_moved.connect(mirror_move)

func mirror_move(player_dir: Vector2):
	var mirror_dir = -player_dir
	var can_move = true
	if mirror_dir == Vector2(0, -1) and $up.is_colliding():
		can_move = false
	elif mirror_dir == Vector2(0, 1) and $down.is_colliding():
		can_move = false
	elif mirror_dir == Vector2(-1, 0) and $left.is_colliding():
		can_move = false
	elif mirror_dir == Vector2(1, 0) and $right.is_colliding():
		can_move = false
	
	if can_move:
		_move(mirror_dir)

func _move(dir: Vector2):
	global_position += dir * tile_size
	$Sprite2D.global_position -= dir * tile_size
	
	if sprite_node_pos_tween:
		sprite_node_pos_tween.kill()
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property($Sprite2D, "global_position", global_position, 0.185).set_trans(Tween.TRANS_SINE)
	
	sprite_node_pos_tween.finished.connect(_on_tween_finished, CONNECT_ONE_SHOT)

func _on_tween_finished():
	movement_finished.emit()
