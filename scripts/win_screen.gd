extends Node2D

func _input(event):
	if event is InputEventMouseButton or event is InputEventKey:
		hide()
