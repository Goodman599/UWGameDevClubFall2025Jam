# Requires a LevelTileMap and Spirit reference to function

extends ControllableCharacter

signal won

@export var spirit : Spirit

@onready var overlay = $"../Overlay"

var potion_status = 0    # 1 = destroy, 2 = freeze, 3 = mirror, 4 = speed
var potion_duration = 0

func _ready():
	movement_completed.connect(check_win)


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
	
	# Check if still in movement animation
	if ((!movement_tween or !movement_tween.is_running() or !spirit.movement_tween.is_running())):
		if !can_move:
			return
			
		var spirit_move_dir = move_dir
		if potion_status == 4:
			spirit_move_dir = -spirit_move_dir
		if potion_status == 3:
			spirit_move_dir *= 2
		# Call spirit to check if spirit target tile is walkable first
		# Receives a value of 0, 0 if the check fails
		spirit_move_dir = spirit.mirror_move(spirit_move_dir, potion_status)
		if spirit_move_dir != Vector2i(0, 0) or potion_status == 2:
			# Check own move
			if check_tile_walkability(target_tile_position, potion_status):
				move(move_dir)
				spirit.move(spirit_move_dir)
				count_down()
			else: # If this could not move
				tilemap.clear_marked_tile()
		

func potion_used():
	updateVignette()

func check_win():
	await spirit.movement_tween.finished
	if global_position == spirit.global_position:
		can_move = false
		spirit.can_move = false
		emit_signal("won")
		
func count_down():
	if potion_duration > 0:
		potion_duration -= 1
	if potion_duration == 0:
		potion_status = 0
	updateVignette()

func updateVignette():
	overlay.update(potion_status, potion_duration)
