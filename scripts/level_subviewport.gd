class_name LevelSubviewport
extends SubViewportContainer

signal disappeared

func _ready():
	modulate.a = 0
		

func appear():
	visible = true
	var appear_tween = get_tree().root.create_tween()
	appear_tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 1)

func disappear():
	var disappear_tween = get_tree().root.create_tween()
	disappear_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1)
	await disappear_tween.finished
	visible = false
	$SubViewport.remove_child($SubViewport.get_child(1))
	emit_signal("disappeared")
