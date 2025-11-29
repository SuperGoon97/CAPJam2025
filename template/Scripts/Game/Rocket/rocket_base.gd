class_name RocketBase extends RigidBody3D

signal do_socket_overlap_check

const CUSTOM_GENERIC_6_DOF_JOINT_3D = preload("res://Scenes/Components/custom_generic_6dof_joint3d.tscn")
const CUSTOM_PIN_JOINT = preload("res://Scenes/Components/custom_pin_joint.tscn")


var _parent:RigidBody3D = null
var _attached_socket:RocketSocketPoint
var _array_joints:Array[PinJoint3D]
var _scoring_part:bool = false
var _launched:bool = false
var do_once_sold:bool = true
var resource_data:RocketPartResource
@onready var rocket_collision_shape: CollisionShape3D = $RocketCollisionShape
@onready var rocket_socket_check_area: RocketArea3D = $RocketSocketCheckArea

func _ready() -> void:
	if !GVar.signal_bus:
		await GVar.scene_manager.game_ready
	GVar.signal_bus.physics_enabled.connect(unfreeze)
	if is_in_group("ShipRoot"):
		_scoring_part = true
		GVar.signal_bus.rocket_launch.connect(set_launched)
	else:
		rocket_socket_check_area.area_left_clicked.connect(area_left_clicked)

func set_launched():
	_launched = true

func _physics_process(_delta: float) -> void:
	if _launched:
		for node in _array_joints:
			if global_position.distance_to(node.global_position) > 1.0:
				explode()
		if _scoring_part:
			GVar.signal_bus.rocket_root_height_changed.emit(global_position.y)

func explode():
		for i in _array_joints.size():
			print_rich("[color=red]Successful break[/color]")
			var joint:Node3D = _array_joints.pop_back()
			joint.call_deferred("queue_free")
			

func setup(new_parent:RigidBody3D,new_attached_socket:RocketSocketPoint,_mass:float):
	mass = _mass
	_parent = new_parent
	_attached_socket = new_attached_socket
	var direction_vec:Vector3 = Vector3(_attached_socket.global_position - _parent.global_position).normalized().round()
	var half_rocket_bounds:Vector3 = rocket_collision_shape.shape.size
	var position_mod:Vector3 = (direction_vec * half_rocket_bounds * 1.01)
	global_position = _parent.global_position + position_mod
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
		var new_joint:PinJoint3D = CUSTOM_PIN_JOINT.instantiate()
		socket.get_parent().add_child(new_joint)
		new_joint.exclude_nodes_from_collision = false
		new_joint.global_position = socket.global_position
		new_joint.node_a = socket.get_parent().get_path()
		new_joint.node_b = self.get_path()
		_array_joints.push_back(new_joint)
		print_rich("[color=blue]"+str(_array_joints)+"[/color]")
		socket.set_socket_enabled(false)
	do_socket_overlap_check.emit()

func area_left_clicked():
	var children:Array[Node] = get_children()
	for child in children:
		if child is RocketBase:
			return
	if do_once_sold:
		GVar.signal_bus.rocket_part_sold.emit(self)
		do_once_sold = !do_once_sold

func unfreeze():
	set_deferred("freeze",false)
