extends TextureButton

func _ready():
	normal()
	mouse_entered.connect(hovered)
	button_down.connect(held)
	mouse_exited.connect(normal)
	button_up.connect(normal)
	
func normal():
	if !button_pressed:
		modulate = Color(0.9, 0.9, 0.9)
	
func hovered():
	modulate = Color(1, 1, 1)
	
func held():
	modulate = Color(0.8, 0.8, 0.8)

func appear():
	show()
	modulate.a = 0
	var appear_tween = get_tree().root.create_tween()
	appear_tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 1)
