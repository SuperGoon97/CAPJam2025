class_name RocketSocketPoint extends Node3D

@onready var rocket_socket_area_3d: Area3D = $RocketSocketArea3D

func _ready() -> void:
	rocket_socket_area_3d.mouse_entered.connect(_on_mouse_entered_area)
	rocket_socket_area_3d.mouse_exited.connect(_on_mouse_exited_area)
	rocket_socket_area_3d.input_event.connect(_input_event)

func _on_mouse_entered_area():
	GVar.signal_bus.mouse_entered_socket.emit(self)

func _on_mouse_exited_area():
	GVar.signal_bus.mouse_exited_socket.emit()

func _input_event(_camera:Node,event:InputEvent,_event_position:Vector3,_normal:Vector3,_shape_idx:int):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		GVar.signal_bus.socket_clicked.emit(self)
	pass

func set_socket_enabled(state:bool):
	if state == true:
		visible = true
		if !rocket_socket_area_3d.mouse_entered.is_connected(_on_mouse_entered_area):
			rocket_socket_area_3d.mouse_entered.connect(_on_mouse_entered_area)
			rocket_socket_area_3d.mouse_exited.connect(_on_mouse_exited_area)
			rocket_socket_area_3d.input_event.connect(_input_event)
	else:
		visible = false
		if rocket_socket_area_3d.mouse_entered.is_connected(_on_mouse_entered_area):
			rocket_socket_area_3d.mouse_entered.disconnect(_on_mouse_entered_area)
			rocket_socket_area_3d.mouse_exited.disconnect(_on_mouse_exited_area)
			rocket_socket_area_3d.input_event.disconnect(_input_event)
	pass
