extends Control

@export var level_subviewport : LevelSubviewport
@onready var potion_parent_node : Node2D = $Sidebar/Potions
@onready var level_buttons: Control = $LevelSelectSubviewport/SubViewport/LevelButtons

@onready var solidStarLineTexture = preload("res://assets/sprites/pentagram/pentagramsStarLineWhite.png")
@onready var solidSideLineTexture = preload("res://assets/sprites/pentagram/pentagramsSideLineWhite.png")

var current_level_number : int = -1
var max_completed_level = 0

var screen_tween : Tween

var in_transition := false

func _ready():
	level_subviewport.disappeared.connect($LevelAppearSound.play)
	
	for i in range(level_buttons.get_child_count()):
		var button = level_buttons.get_children()[i]
		if button is TextureButton:
			@warning_ignore("integer_division")
			level_buttons.get_children()[i].pressed.connect(level_chosen.bind((i / 2 + 1)))
			if i / 2 > max_completed_level:
				level_buttons.get_children()[i].hide()

func _process(_delta):
	if Input.is_action_just_pressed("reset") and current_level_number > -1 and !screen_tween.is_running():
		$LevelSubviewport/SubViewport.remove_child($LevelSubviewport/SubViewport.get_child(1))
		level_chosen(current_level_number)


func level_chosen(level_number : int):
	if in_transition:
		return
	
	var current_level = load("res://scenes/levels/level_" + str(level_number) + ".tscn").instantiate()
	
	$LevelSelectedSound.play()
	
	current_level.get_node("LevelFundamentals/Player").won.connect(zoom_out_on_won)
	$LevelSubviewport/SubViewport.add_child(current_level)
	current_level_number = level_number
	zoom_in(level_buttons.get_child(level_number * 2 - 1).global_position)
	# Set the "current_level" in all potions to get resource count
	# Gets the "LevelFundamentals" node
	for potion_node in potion_parent_node.get_children():
		potion_node.level_node = current_level.get_child(0)
		potion_node.start_level()


func zoom_in(target_position : Vector2):
	level_subviewport.appear()
	in_transition = true
	
	screen_tween = get_tree().root.create_tween()
	screen_tween.tween_property($LevelSelectSubviewport/SubViewport/LevelSelectCamera, "zoom", Vector2(2, 2), 1)
	screen_tween.set_ease(Tween.EASE_IN_OUT)
	screen_tween.set_trans(Tween.TRANS_QUAD)
	screen_tween.parallel().tween_property($LevelSelectSubviewport/SubViewport/LevelSelectCamera, "global_position", target_position, 0.75)
	
	await screen_tween.finished
	
	in_transition = false

func zoom_out_on_won():
	$LevelComplete.play()
	
	var new_level_unlocked := false # Keep track of this for animation waiting
	if current_level_number > max_completed_level:
		new_level_unlocked = true
		
		if max_completed_level < 5:
			$LevelSelectSubviewport/SubViewport/LevelButtons.get_child(max_completed_level * 2).texture_normal = solidStarLineTexture
		else:
			$LevelSelectSubviewport/SubViewport/LevelButtons.get_child(max_completed_level * 2).texture_normal = solidSideLineTexture
		max_completed_level += 1
		if max_completed_level == 10:
			print("WINNN")
		level_subviewport.disappeared.connect($LevelSelectSubviewport/SubViewport/LevelButtons.get_child(max_completed_level * 2).appear, CONNECT_ONE_SHOT)
		
	var cauldron_node = get_node("Sidebar/Cauldron")
	@warning_ignore("integer_division")
	cauldron_node.set_fetus_stage(floor(max_completed_level / 2) + 1)

	in_transition = true
	
	level_subviewport.disappear()
	# Subviewport/subviewport.level_X/level_fundamentals/LevelCamera
	$LevelSubviewport/SubViewport.get_child(1).get_node("LevelFundamentals/LevelCamera").zoom_out()
	
	
	current_level_number = -1
	
	for potion_node in potion_parent_node.get_children():
		potion_node.level_node = null
		potion_node.start_level()
	
	screen_tween = get_tree().root.create_tween()
	screen_tween.tween_property($LevelSelectSubviewport/SubViewport/LevelSelectCamera, "zoom", Vector2(1, 1), 1)
	screen_tween.set_ease(Tween.EASE_IN_OUT)
	screen_tween.set_trans(Tween.TRANS_QUAD)
	screen_tween.parallel().tween_property($LevelSelectSubviewport/SubViewport/LevelSelectCamera, "global_position", Vector2(724, 541), 0.75)
	
	if !new_level_unlocked:
		await level_subviewport.disappeared
		in_transition = false
	else:
		await $LevelAppearSound.finished
		in_transition = false
