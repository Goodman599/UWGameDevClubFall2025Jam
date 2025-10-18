extends Node2D

#@export var resource_id = -1

func _ready() -> void:
	updateResourceCounts()

func updateResourceCounts():
	# I LOVE HARD CODING NODE PATHS
	var counts = $"../../".resources
	for i in 5:
		var label = get_node("Control/count_" + str(i))
		label.text = str(counts[i])
