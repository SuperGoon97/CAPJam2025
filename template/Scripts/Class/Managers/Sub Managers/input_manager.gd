class_name InputManager
extends ManagerBase

func _game_ready():
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		GVar.signal_bus.player_right_click.emit()
