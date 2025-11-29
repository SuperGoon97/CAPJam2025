class_name RocketBase extends RigidBody3D

signal do_socket_overlap_check

var _parent:RigidBody3D = null
var _attached_socket:RocketSocketPoint

@onready var rocket_collision_shape: CollisionShape3D = $RocketCollisionShape
@onready var rocket_socket_check_area: Area3D = $RocketSocketCheckArea

func _ready() -> void:
	if !GVar.signal_bus:
		await GVar.scene_manager.game_ready
	GVar.signal_bus.physics_enabled.connect(unfreeze)

func setup(new_parent:RigidBody3D,new_attached_socket:RocketSocketPoint):
	_parent = new_parent
	_attached_socket = new_attached_socket
	var direction_vec:Vector3 = Vector3(_attached_socket.global_position - _parent.global_position).normalized().round()
	var half_rocket_bounds:Vector3 = rocket_collision_shape.shape.size
	var position_mod:Vector3 = (direction_vec * half_rocket_bounds * 1.01)
	global_position = _parent.global_position + position_mod
	
	await get_tree().physics_frame
	
	var overlapping_areas_array:Array[Area3D] = rocket_socket_check_area.get_overlapping_areas()
	var overlapping_sockets:Array[RocketSocketPoint]
	
	for area in overlapping_areas_array:
		var area_parent = area.get_parent()
		if area_parent is RocketSocketPoint:
			if !area_parent.get_parent() == self:
				overlapping_sockets.push_back(area.get_parent())
	
	for socket in overlapping_sockets:
		var new_joint:Generic6DOFJoint3D = Generic6DOFJoint3D.new()
		add_child(new_joint)
		new_joint.exclude_nodes_from_collision = false
		new_joint.global_position = socket.global_position
		new_joint.node_a = self.get_path()
		new_joint.node_b = socket.get_parent().get_path()
		socket.set_socket_enabled(false)
	do_socket_overlap_check.emit()
func unfreeze():
	set_deferred("freeze",false)
