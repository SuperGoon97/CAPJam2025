class_name RocketPart extends CollisionShape3D

signal do_socket_overlap_check

var do_once_sold:bool = true
var resource_data:RocketPartResource
@onready var rocket_socket_check_area: RocketArea3D = $RocketSocketCheckArea
func _ready() -> void:
	if !GVar.signal_bus:
		await GVar.scene_manager.game_ready
	rocket_socket_check_area.area_left_clicked.connect(area_left_clicked)

#func explode():
		#for i in _array_joints.size():
			#print_rich("[color=red]Successful break[/color]")
			#var joint:Node3D = _array_joints.pop_back()
			#joint.call_deferred("queue_free")
			#

func setup(attached_socket:RocketSocketPoint):
	var temp_pos = attached_socket.get_parent().global_position
	var direction_vec:Vector3 = Vector3(attached_socket.global_position - temp_pos).normalized().round()
	var half_rocket_bounds:Vector3 = shape.size
	var position_mod:Vector3 = (direction_vec * half_rocket_bounds * 1.025)
	global_position = temp_pos + position_mod
	await get_tree().physics_frame
	await get_tree().physics_frame
	var overlapping_areas_array:Array[Area3D] = rocket_socket_check_area.get_overlapping_areas()
	var overlapping_sockets:Array[RocketSocketPoint]
	for area in overlapping_areas_array:
		var area_parent = area.get_parent()
		if area_parent is RocketSocketPoint:
			if !area_parent.get_parent() == self:
				overlapping_sockets.push_back(area.get_parent())
	for socket in overlapping_sockets:
		#var new_joint:PinJoint3D = CUSTOM_PIN_JOINT.instantiate()
		#socket.get_parent().add_child(new_joint)
		#new_joint.exclude_nodes_from_collision = false
		#new_joint.global_position = socket.global_position
		#new_joint.node_a = socket.get_parent().get_path()
		#new_joint.node_b = self.get_path()
		#_array_joints.push_back(new_joint)
		#print_rich("[color=blue]"+str(_array_joints)+"[/color]")
		socket.set_socket_enabled(false)
	do_socket_overlap_check.emit()

func area_left_clicked():
	var children:Array[Node] = get_children()
	for child in children:
		if child is RocketPart:
			return
	if do_once_sold:
		GVar.signal_bus.rocket_part_sold.emit(self)
		do_once_sold = !do_once_sold
