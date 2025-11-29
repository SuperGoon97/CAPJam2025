extends ButtonBase



func _ready() -> void:
	pass


func _on_pressed() -> void:
	GVar.signal_bus.physics_enabled.emit()
	GVar.signal_bus.rocket_launch.emit()
	
