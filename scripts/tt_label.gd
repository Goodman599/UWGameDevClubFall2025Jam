extends Label


func _ready():
	var label_fade_out = self
	
	var label_fade_in = $"../Label2"
	
	label_fade_in.modulate.a = 0
	
	var tween = create_tween()
	
	tween.set_parallel(true)
	
	tween.tween_property(label_fade_out, "modulate:a", 0.0, 1.0).set_delay(3.0)

	tween.tween_property(label_fade_in, "modulate:a", 1.0, 1.0).set_delay(3.0)
