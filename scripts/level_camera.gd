extends Camera2D

@onready var starting_zoom = zoom

func _ready():
	zoom /= 10
	zoom_in()
	

func zoom_in():
	var zoom_tween = get_tree().root.create_tween()
	zoom_tween.tween_property(self, "zoom", starting_zoom, 1)
	await zoom_tween.finished
	
func zoom_out():
	var zoom_tween = get_tree().root.create_tween()
	zoom_tween.tween_property(self, "zoom", starting_zoom / 10, 1)
