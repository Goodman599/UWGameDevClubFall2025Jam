extends Control

@export var level_subviewport : LevelSubviewport

@onready var potion_parent_node : Node2D = $Sidebar/Potions

@onready var level_1 = preload("res://scenes/levels/level_1.tscn")


func _ready():
	level_selected(1)


func level_selected(level_number : int):
	# TODO: Instantiate level scene
	var current_level = level_1.instantiate()
	add_child(current_level)
	level_subviewport.appear()
	for potion_node in potion_parent_node.get_children():
		potion_node.level_node = current_level
