class_name ButtonBase extends Button

# @export var button_sound:AudioStreamMP3 = preload("uid://dyl6khb4vxuhn")

@export var sound_array:Array[AudioStreamMP3] = []
var bus = &"SFX"

func _ready() -> void:
	mouse_exited.connect(_on_mouse_exit)
	sound_array = []
	pass
	
func _pressed() -> void:
	if sound_array.size() == 0: return
	GSound.play_sound_main_camera(sound_array.pick_random(),bus)
	pass

func _on_mouse_exit():
	release_focus()
	pass
