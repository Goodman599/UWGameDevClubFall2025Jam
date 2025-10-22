extends Node2D

var selected = false
var mouse_offset = Vector2(0,0)
var level_node : Node2D
var level_started = false

var destroy_texture = preload("res://assets/sprites/potions/potion_destroy.png")
var freeze_texture = preload("res://assets/sprites/potions/potion_freeze.png")
var mirror_texture = preload("res://assets/sprites/potions/potion_mirror.png")
var speed_texture = preload("res://assets/sprites/potions/potion_speed.png")

var crafting_costs = {
	1 : [1, 0, 0, 0],
	2 : [0, 1, 0, 0],
	3 : [0, 0, 1, 0],
	4 : [0, 0, 0, 1],
}

@export var id = -1
# potion IDs:
# 1 = destroy, 2 = freeze, 3 = mirror, 4 = speed

@onready var starting_position = global_position
@onready var area = $PotionHitbox

func _ready() -> void:
	$PotionSprite.scale = Vector2(0.25, 0.25)
	if (id == 1):
		$PotionSprite.texture = destroy_texture
	if (id == 2):
		$PotionSprite.texture = freeze_texture
	if (id == 3):
		$PotionSprite.texture = mirror_texture
	if (id == 4):
		$PotionSprite.texture = speed_texture

func start_level():
	updateShader()
	selected = false

func _process(delta):
	if selected and canCraft():
		followMouse()
	if level_started == false and level_node != null:
		updateShader()
		level_started = true
		
func followMouse():
	global_position = get_global_mouse_position() + mouse_offset

func _on_potion_hitbox_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and level_started:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				selected = false
				checkCauldronCollision()
				global_position = starting_position
			else:
				mouse_offset = global_position - get_global_mouse_position()
				selected = true
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			var journal_node = $"../../JournalEntry"
			journal_node.setTexture(id)
			journal_node.fade_in()
			
		
func checkCauldronCollision():
	var overlapping = area.get_overlapping_areas()

	for other in overlapping:
		if other.name == "CauldronHitbox":
			# crafting
			if canCraft():
				craft()				
				return
			
func canCraft() -> bool:
	if level_node == null:
		print("No level selected!")
		return false
	var remainingResources = level_node.resources
	for i in len(remainingResources):
		if remainingResources[i] < crafting_costs.get(id)[i]:
			return false
	return true
			
func craft():	
	var remainingResources = level_node.resources
	for i in len(remainingResources):
		remainingResources[i] -= crafting_costs.get(id)[i]
		var counter = level_node.get_node("ResourceCount")
		counter.updateResourceCounts()
	var player_node = level_node.get_node("Player")
	player_node.potion_status = id
	player_node.potion_duration = 2
	updateShader()
		
func updateShader():
	if canCraft():
		$PotionSprite.material.set_shader_parameter("active", false)
	else:
		$PotionSprite.material.set_shader_parameter("active", true)
	
