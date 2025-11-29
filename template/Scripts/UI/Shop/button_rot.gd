extends ButtonBase

@export var rotate_right = false

func _ready() -> void:
	pass # Replace with function body.




func _on_pressed() -> void:
	if rotate_right == true:
		GVar.signal_bus.rotate_cam_right.emit()
	else:
		GVar.signal_bus.rotate_cam_left.emit()
