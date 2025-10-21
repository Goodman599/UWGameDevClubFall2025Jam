class_name LevelSubviewport
extends SubViewportContainer


func _ready():
	modulate.a = 0
		

func appear():
	visible = true
	var appear_tween = get_tree().root.create_tween()
	appear_tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 1)

func disappear():
	visible = true
	var disappear_tween = get_tree().root.create_tween()
	disappear_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1)
	await disappear_tween.finished
	visible = false
