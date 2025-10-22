extends Control

@onready var UI_camera : Camera2D = $UICamera

const SCREEN_POSITIONS = {
	"start" : Vector2(0, 0),
	"level_select" : Vector2(1920, 0),
}
const SCREEN_TRANSITION_TIME = 3
const SCREEN_SIZE = Vector2(1920, 1080)

var screen_tween : Tween

func _ready() -> void:
	$MainMenuRoot.pressed.connect(go_to_screen.bind(SCREEN_POSITIONS["level_select"]))
	
	
	
func go_to_screen(screen_position : Vector2):
	if screen_tween and screen_tween.is_running():
		return
	$LevelSelectRoot.in_transition = true
	screen_tween = get_tree().root.create_tween()
	screen_tween.set_ease(Tween.EASE_IN_OUT)
	screen_tween.set_trans(Tween.TRANS_CUBIC)
	screen_tween.tween_property(UI_camera, "position", screen_position + SCREEN_SIZE / 2, SCREEN_TRANSITION_TIME)
	$Transition.play()
	await screen_tween.finished
	$LevelSelectRoot.in_transition = false
