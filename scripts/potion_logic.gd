extends Node2D

var selected = false
var mouse_offset = Vector2(0,0)
var level_node : Node2D

'''
# gets the level_node from the ancestral family tree
func _ready() -> void:
	var gameplay_scene_node = get_parent().get_parent().get_parent()
	print(gameplay_scene_node.name)
	level_node = gameplay_scene_node.get_child(gameplay_scene_node.get_child_count() - 1)
'''

var crafting_costs = {
	0 : [1, 0, 0, 0, 0],
	1 : [0, 1, 0, 0, 0],
	2 : [0, 0, 1, 0, 0],
	3 : [0, 0, 0, 1, 0],
	4 : [0, 0, 0, 0, 1],
}

@export var id = -1

@onready var starting_position = global_position
@onready var area = $PotionHitbox

func _process(delta):
	if selected:
		followMouse()
		
func followMouse():
	global_position = get_global_mouse_position() + mouse_offset


func _on_potion_hitbox_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			selected = false
			checkCouldronCollision()
			global_position = starting_position
		else:
			mouse_offset = global_position - get_global_mouse_position()
			selected = true
		
func checkCouldronCollision():
	var overlapping = area.get_overlapping_areas()

	for other in overlapping:
		if other.name == "CauldronHitbox":
			# crafting
			if canCraft():
				print("potion id " + str(id) + " used")
			
func canCraft() -> bool:
	if level_node == null:
		print("No level selected!")
		return false
	print(level_node.name)
	var remainingResources = level_node.resources
	for i in len(remainingResources):
		if remainingResources[i] < crafting_costs.get(id)[i]:
			print("insufficient resources!")
			return false
	for i in len(remainingResources):
		remainingResources[i] -= crafting_costs.get(id)[i]
		var counter = level_node.get_node("ResourceCount")
		counter.updateResourceCounts()
	return true
