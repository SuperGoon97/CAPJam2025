class_name RocketBase extends RigidBody3D

var _parent:RigidBody3D = null
var _attached_socket:RocketSocketPoint

@onready var rocket_collision_shape: CollisionShape3D = $RocketCollisionShape

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
	
	var new_joint:Generic6DOFJoint3D = Generic6DOFJoint3D.new()
	add_child(new_joint)
	new_joint.exclude_nodes_from_collision = false
	#new_joint.set_param(PinJoint3D.PARAM_BIAS,0.8)
	new_joint.global_position = _attached_socket.global_position
	new_joint.node_a = self.get_path()
	new_joint.node_b = _parent.get_path()

func unfreeze():
	set_deferred("freeze",false)
