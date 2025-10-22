extends Label

func _ready():
	var label_fade_out = self
	

	var tween = create_tween()

	tween.tween_property(label_fade_out, "modulate:a", 0.0, 1.0).set_delay(3.0)

	tween.set_parallel(true)

	tween.set_parallel(false)

	tween.tween_interval(5.0)
