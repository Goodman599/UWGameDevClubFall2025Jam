extends Sprite2D

var start_position: Vector2
@export var float_amplitude: float = 5.0  # how many pixels up/down
@export var float_speed: float = 0.5 
var time_passed: float

func _ready() -> void:
	start_position = position
	
func _process(delta: float) -> void:
	time_passed += delta
	position.y = start_position.y + sin(time_passed * float_speed * PI * 2) * float_amplitude
