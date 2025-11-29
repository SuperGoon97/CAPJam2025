class_name RocketArea3D extends Area3D

signal area_left_clicked

func _ready() -> void:
	input_event.connect(_input_event)

func _input_event(_camera:Node,_event:InputEvent,_event_position:Vector3,_normal:Vector3,_shape_idx:int):
	if _event is InputEventMouseButton and _event.is_released() and _event.button_index == 1:
		area_left_clicked.emit()
