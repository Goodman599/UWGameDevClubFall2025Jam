extends Node2D

func _ready() -> void:
	updateResourceCounts()

func updateResourceCounts():
	var counts = $"../".resources
	
	for i in 5:
		var label = get_node("Control/count_" + str(i))
		label.text = str(counts[i])
