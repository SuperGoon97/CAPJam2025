class_name RocketSocketPoint extends Node3D

@onready var rocket_socket_area_3d: Area3D = $RocketSocketArea3D
var _socket_enabled:bool = true
var mouse_is_over:bool = false

func _ready() -> void:
	rocket_socket_area_3d.mouse_entered.connect(_on_mouse_entered_area)
	rocket_socket_area_3d.mouse_exited.connect(_on_mouse_exited_area)
	if !GVar.signal_bus:
		await GVar.scene_manager.game_ready
	GVar.signal_bus.player_grabbed_rocket_part_from_shop.connect(_player_grabbed_rocket_part_from_shop)
	GVar.signal_bus.rocket_part_added.connect(_request_visibility_change.bind(false))
	GVar.signal_bus.player_right_click.connect(_request_visibility_change.bind(false))
	GVar.signal_bus.player_release_left_click.connect(_request_visibility_change.bind(false))
	_request_visibility_change(false)
	var rocket_parent:RocketBase = get_parent()
	rocket_parent.do_socket_overlap_check.connect(_overlap_check)
func _on_mouse_entered_area():
	mouse_is_over = true
	GVar.signal_bus.mouse_entered_socket.emit(self)

func _on_mouse_exited_area():
	mouse_is_over = false
	GVar.signal_bus.mouse_exited_socket.emit()

func _input(event: InputEvent) -> void:
	if mouse_is_over:
		if event is InputEventMouseButton and event.is_released() and event.button_index == 1:
			GVar.signal_bus.socket_clicked.emit(self)

func _request_visibility_change(state:bool):
	if _socket_enabled == false: return
	else:
		visible = state

func _player_grabbed_rocket_part_from_shop(_args):
	_request_visibility_change(true)

func _overlap_check():
	var overlapping_areas:Array[Area3D] = rocket_socket_area_3d.get_overlapping_areas()
	for area in overlapping_areas:
		if area.get_parent() is RocketBase and area.get_parent() != get_parent():
			if _socket_enabled:
				set_socket_enabled(false)
				return
	if !_socket_enabled:
		set_socket_enabled(true)

func set_socket_enabled(state:bool):
	_socket_enabled = state
	if state == true:
		visible = true
		set_area_monitor_state(true)
		if !rocket_socket_area_3d.mouse_entered.is_connected(_on_mouse_entered_area):
			rocket_socket_area_3d.mouse_entered.connect(_on_mouse_entered_area)
			rocket_socket_area_3d.mouse_exited.connect(_on_mouse_exited_area)
	else:
		visible = false
		set_area_monitor_state(false)
		if rocket_socket_area_3d.mouse_entered.is_connected(_on_mouse_entered_area):
			rocket_socket_area_3d.mouse_entered.disconnect(_on_mouse_entered_area)
			rocket_socket_area_3d.mouse_exited.disconnect(_on_mouse_exited_area)

func set_area_monitor_state(state:bool):
	rocket_socket_area_3d.set_deferred("monitoring",state)
	rocket_socket_area_3d.set_deferred("monitorable",state)
