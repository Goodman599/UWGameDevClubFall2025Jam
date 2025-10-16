extends Node2D

var selected = false
var mouse_offset = Vector2(0,0)

@export var id = 0

@onready var starting_position = global_position
@onready var area = $PotionHitbox

var crafting_cost = {
	"a":1,
	"b":2
}

func _process(delta):
	if selected:
		followMouse();
		
func followMouse():
	position = get_global_mouse_position() + mouse_offset


func _on_potion_hitbox_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			selected = false
			# TODO: if dropped on couldron:
			checkCouldronCollision()
			position = starting_position
		else:
			mouse_offset = position - get_global_mouse_position()
			selected = true
		
func checkCouldronCollision():
	var overlapping = area.get_overlapping_areas()

	for other in overlapping:
		if other.name == "CauldronArea":
			print(name + " used!")
			# TODO: potion effects
