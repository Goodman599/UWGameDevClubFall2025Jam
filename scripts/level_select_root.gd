extends Control

@export var level_subviewport : LevelSubviewport
@onready var potion_parent_node : Node2D = $Sidebar/Potions
@onready var level_buttons: Control = $LevelSelectSubviewport/SubViewport/LevelButtons

signal level_started(level_number : int)

@onready var solidStarLineTexture = preload("res://assets/sprites/pentagram/pentagramsStarLineWhite.png")
@onready var solidSideLineTexture = preload("res://assets/sprites/pentagram/pentagramsSideLineWhite.png")

var current_level_number : int
var max_completed_level = 0

func _ready():
	for i in range(level_buttons.get_child_count()):
		var button = level_buttons.get_children()[i]
		if button is TextureButton:
			@warning_ignore("integer_division")
			level_buttons.get_children()[i].pressed.connect(level_chosen.bind((i / 2 + 1)))
			if i > max_completed_level:
				pass
				#level_buttons.get_children()[i].hide()

func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		level_chosen(current_level_number)


func level_chosen(level_number : int):
	# If there is already a level loaded, unload it
	var current_level = load("res://scenes/levels/level_" + str(level_number) + ".tscn").instantiate()
	if $LevelSubviewport/SubViewport.get_child_count() > 1:
		var prior_loaded_level = $LevelSubviewport/SubViewport.get_child(1)
		if prior_loaded_level != current_level:
			$LevelSubviewport/SubViewport.remove_child(prior_loaded_level)
	
	current_level.get_node("LevelFundamentals/Player").won.connect(zoom_out_on_won)
	$LevelSubviewport/SubViewport.add_child(current_level)
	current_level_number = level_number
	zoom_in(level_buttons.get_child(level_number * 2 - 1).global_position)
	# Set the "current_level" in all potions to get resource count
	# Gets the "LevelFundamentals" node
	for potion_node in potion_parent_node.get_children():
		potion_node.level_node = current_level.get_child(0)
		potion_node.start_level()
	var player_node = current_level.get_node("LevelFundamentals/Player")
	player_node.potion_status = 0
	player_node.potion_duration = 0


func zoom_in(target_position : Vector2):
	level_subviewport.appear()
	
	var screen_tween = get_tree().root.create_tween()
	screen_tween.tween_property($LevelSelectSubviewport/SubViewport/LevelSelectCamera, "zoom", Vector2(2, 2), 1)
	screen_tween.set_ease(Tween.EASE_IN_OUT)
	screen_tween.set_trans(Tween.TRANS_QUAD)
	screen_tween.parallel().tween_property($LevelSelectSubviewport/SubViewport/LevelSelectCamera, "global_position", target_position, 0.75)
	

func zoom_out_on_won():
	if current_level_number > max_completed_level:
		if max_completed_level < 5:
			$LevelSelectSubviewport/SubViewport/LevelButtons.get_child(max_completed_level * 2).texture_normal = solidStarLineTexture
		else:
			$LevelSelectSubviewport/SubViewport/LevelButtons.get_child(max_completed_level * 2).texture_normal = solidSideLineTexture
		max_completed_level += 1
		$LevelSelectSubviewport/SubViewport/LevelButtons.get_child(max_completed_level * 2).show()
	level_subviewport.disappear()
	# Subviewport/subviewport.level_X/level_fundamentals/LevelCamera
	$LevelSubviewport/SubViewport.get_child(1).get_node("LevelFundamentals/LevelCamera").zoom_out()
	
	var screen_tween = get_tree().root.create_tween()
	screen_tween.tween_property($LevelSelectSubviewport/SubViewport/LevelSelectCamera, "zoom", Vector2(1.3, 1), 1)
	screen_tween.set_ease(Tween.EASE_IN_OUT)
	screen_tween.set_trans(Tween.TRANS_QUAD)
	screen_tween.parallel().tween_property($LevelSelectSubviewport/SubViewport/LevelSelectCamera, "global_position", Vector2(724, 541), 0.75)
