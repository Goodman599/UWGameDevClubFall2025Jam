extends Control

@export var level_subviewport : LevelSubviewport

@onready var potion_parent_node : Node2D = $Sidebar/Potions
@onready var level_1 = preload("res://scenes/levels/level_1.tscn")
@onready var level_buttons: Control = $LevelSelectSubviewport/SubViewport/LevelButtons


func _ready():
	for i in range(level_buttons.get_child_count()):
		level_buttons.get_children()[i].pressed.connect(level_chosen.bind(i + 1))


func level_chosen(level_number : int):
	# TODO: Instantiate level scene
	var current_level = level_1.instantiate()
	$LevelSubviewport/SubViewport.add_child(current_level)
	level_subviewport.appear()
	zoom_in(level_buttons.get_child(level_number - 1).global_position)
	# Set the "current_level" in all potions to get resource count
	# Gets the "LevelFundamentals" node
	for potion_node in potion_parent_node.get_children():
		potion_node.level_node = current_level.get_child(0)

func zoom_in(target_position : Vector2):
	var screen_tween = get_tree().root.create_tween()
	screen_tween.tween_property($LevelSelectSubviewport/SubViewport/LevelSelectCamera, "zoom", Vector2(2, 2), 1)
	screen_tween.set_ease(Tween.EASE_IN_OUT)
	screen_tween.set_trans(Tween.TRANS_QUAD)
	screen_tween.parallel().tween_property($LevelSelectSubviewport/SubViewport/LevelSelectCamera, "global_position", target_position, 1)
	
