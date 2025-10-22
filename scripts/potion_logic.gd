extends Node2D

var selected = false
var mouse_offset = Vector2(0,0)
var level_node : Node2D
var level_started = false
var hovering :bool

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
@export var tooltip_scene: PackedScene
var tooltip_instance: Node2D = null



func _ready() -> void:
	self.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	self.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	hovering = false
	area.mouse_entered.connect(showToolTip)
	area.mouse_exited.connect(hideToolTip)

func start_level():
	updateShader()
	selected = false

func _process(_delta):
	if selected and canCraft():
		followMouse()
	if level_started == false and level_node != null:
		updateShader()
		level_started = true
	if hovering:
		update_tooltip_position()				
		
func followMouse():
	global_position = get_global_mouse_position() + mouse_offset

func _on_potion_hitbox_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and level_started and level_node != null:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				z_index = 1
				selected = false
				checkCauldronCollision()
				global_position = starting_position
			else:
				hovering = false
				z_index = 2
				mouse_offset = global_position - get_global_mouse_position()
				selected = true
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			hovering = false
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
	$use_sound.play()
		
func updateShader():
	if level_node == null or canCraft():
		$PotionSprite.material.set_shader_parameter("active", false)
	else:
		$PotionSprite.material.set_shader_parameter("active", true)
	
func update_tooltip_position():
	if tooltip_instance:
		var offset = Vector2(16, 16) 
		tooltip_instance.global_position = get_global_mouse_position() + offset


func showToolTip():
	if level_node == null or canCraft() == false or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		hideToolTip()
		return
	hovering = true
	if tooltip_instance == null:
		tooltip_instance = tooltip_scene.instantiate()
		get_tree().current_scene.add_child(tooltip_instance)
		update_tooltip_position()
	tooltip_instance.show()
	return


func hideToolTip():
	hovering = false
	if tooltip_instance != null:
		tooltip_instance.hide()
	return
