extends Node2D

@export var stay_time: float = 1.0  # seconds to stay fully visible
@export var fade_time: float = 1.0  # seconds to fade out

func _ready() -> void:
	print("added overlay")
	z_index = 5
	# Start fully visible
	modulate.a = 1.0
	
	# Wait for stay_time seconds
	await get_tree().create_timer(stay_time).timeout

	_fade_out()
	
func _fade_out():
	print("fade out started")
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade_time)
	tween.tween_callback(self.queue_free)  # remove node after fade
