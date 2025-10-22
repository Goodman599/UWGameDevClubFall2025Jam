extends Control

signal pressed
var is_enabled := true

func _input(event):
	if event is InputEventMouseButton or event is InputEventKey:
		if is_enabled:
			is_enabled = false
			emit_signal("pressed")
