# Requires a LevelTileMap and Spirit reference to function

extends ControllableCharacter

@export var spirit : Spirit

# This needs to be in the _process() function instead of the _input() function
# IDK why but it starts dropping inputs randomly otherwise
# :)
func _process(_delta):
	var target_tile_position: Vector2i = tilemap.local_to_map(tilemap.to_local(global_position))
	var move_dir := Vector2i(0, 0)
	
	if Input.is_action_just_pressed("ui_up"):
		move_dir = Vector2i (0, -1)
	if Input.is_action_just_pressed("ui_down"):
		move_dir = Vector2i(0, 1)
	if Input.is_action_just_pressed("ui_left"):
		move_dir = Vector2i (-1, 0)
	if Input.is_action_just_pressed("ui_right"):
		move_dir = Vector2i (1, 0)
	
	if move_dir == Vector2i(0, 0):
		return
	target_tile_position += move_dir
	
	# Check if target tile is walkable
	if ((!movement_tween or !movement_tween.is_running()) and check_tile_walkability(target_tile_position)):
		# Call spirit to check if spirit target tile is walkable
		# Receives a value of 0, 0 if the check fails
		var spirit_move_dir: Vector2i = spirit.mirror_move(move_dir)
		if spirit_move_dir != Vector2i(0, 0):
			move(move_dir)
			spirit.move(spirit_move_dir)
