extends Node2D
var overlay_colors
	
func init():
	overlay_colors = [
		Color(1, 0, 0, 0.5),  # Red
		Color(0, 1, 0, 0.5),  # Green
		Color(0, 0, 1, 0.5),  # Blue
		Color(1, 1, 0, 0.5)   # Yellow
	]
	z_index = 6
	$Vignette.z_index = 6
	

func update(potion_state : int , potion_duration : int):
	if potion_duration < 1:
		queue_free()
	if potion_state >= 1 and potion_state <= overlay_colors.size():
		$Vignette.modulate = overlay_colors[potion_state - 1]
	else:
		push_warning("Invalid color index: %d" % potion_state)
	
	
