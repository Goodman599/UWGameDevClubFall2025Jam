extends Node2D

@export var stay_time: float = 1.0  # seconds to stay fully visible
@export var fade_time: float = 1.0  # seconds to fade out

var tween : Tween
	
func fade_out():
	if tween and tween.is_running():
		tween.kill()
		
	show()
	modulate.a = 1.0
	await get_tree().create_timer(stay_time).timeout
	tween = get_tree().root.create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade_time)
	await tween.finished
	hide()  # remove node after fade
