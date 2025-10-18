extends TileMap

@export var player: CharacterBody2D
@export var spirit: CharacterBody2D

func _ready():
	if character:
		character.movement_finished.connect(check_victory)
	if spirit:
		spirit.movement_finished.connect(check_victory)

func check_victory():
	if character and spirit:
		if character.global_position == spirit.global_position:
			print("Congrats!")
			victory()

func victory():
	get_tree().paused = true
