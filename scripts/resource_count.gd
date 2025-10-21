extends CanvasLayer

func _ready() -> void:
	updateResourceCounts()

func updateResourceCounts():
	var counts = $"../".resources
	
	for i in 4:
		var label = get_node("Labels/count_" + str(i))
		label.text = str(counts[i])
