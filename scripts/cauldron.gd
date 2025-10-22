extends Node2D

@onready var anim = $Bubbles

var textures : Array[Resource] = []
var stage = 1

func _ready() -> void:
	textures.append(preload("res://assets/sprites/LittleGuy/stage_1.png"))
	textures.append(preload("res://assets/sprites/LittleGuy/stage_2.png"))
	textures.append(preload("res://assets/sprites/LittleGuy/stage_3.png"))
	textures.append(preload("res://assets/sprites/LittleGuy/stage_4.png"))
	textures.append(preload("res://assets/sprites/LittleGuy/stage_5.png"))
	anim.play("default")

func set_fetus_stage(newStage : int):
	$LittleGuy.texture = textures[newStage - 1]
	stage = newStage
