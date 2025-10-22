extends Node2D

var textures : Array[Resource] = []

func _ready() -> void:
	hide()
	textures.append(preload("res://assets/sprites/journals/journal_1.png"))
	textures.append(preload("res://assets/sprites/journals/journal_2.png"))
	textures.append(preload("res://assets/sprites/journals/journal_3.png"))
	textures.append(preload("res://assets/sprites/journals/journal_4.png"))
	
func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if event is InputEventMouseButton or event is InputEventKey:
			fade_out()
			
func fade_out():
	#print("check")
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)  # fade to alpha=0 over 1 second
	hide()
	
func fade_in():
	show() 
	modulate.a = 0.0 
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)  # alpha -> 1 over 1s
	
func setTexture(id):
	$JournalPage.texture = textures[id - 1]
