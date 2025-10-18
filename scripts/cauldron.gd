extends Node2D

@onready var anim = $Bubbles

func _ready():
	anim.play("default")
