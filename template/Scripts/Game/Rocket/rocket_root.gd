class_name RocketRoot extends RigidBody3D

signal do_socket_overlap_check

const PARTICLES_EXPLOSION = preload("res://Assets/Particles/particles_explosion.tscn")

@export var starting_fuel:float = 100.0

var _parent:RigidBody3D = null
var _attached_socket:RocketSocketPoint
var _array_joints:Array[PinJoint3D]
var _scoring_part:bool = false
var _launched:bool = false
var _exploded:bool = false

var _total_fuel:float = 0.0:
	set(value):
		_total_fuel = value
		GVar.signal_bus.total_fuel_changed.emit(_total_fuel)
var current_fuel:float = 0.0:
	set(value):
		current_fuel = value
		current_fuel_percentage = current_fuel/_total_fuel
		GVar.signal_bus.rocket_fuel_changed.emit(current_fuel,current_fuel_percentage)
		#print_rich("[color=brown] current fuel = " + str(current_fuel) + " %" + str(current_fuel_percentage*100.0) +"[/color]")
var current_fuel_percentage:float = 0.0

var do_once_sold:bool = true
var resource_data:RocketPartResource
@onready var rocket_collision_shape: CollisionShape3D = $RocketCollisionShape
@onready var rocket_socket_check_area: RocketArea3D = $RocketSocketCheckArea

func _ready() -> void:
	if !GVar.signal_bus:
		await GVar.scene_manager.game_ready
	GVar.signal_bus.rocket_tank_added.connect(fuel_tank_added)
	GVar.signal_bus.physics_enabled.connect(unfreeze)
	if is_in_group("ShipRoot"):
		_scoring_part = true
		GVar.signal_bus.rocket_launch.connect(set_launched)
		body_shape_entered.connect(_on_body_shape_entered)
		body_entered.connect(_body_entered)
	else:
		rocket_socket_check_area.area_left_clicked.connect(area_left_clicked)
		
	_total_fuel += starting_fuel

func fuel_tank_added(fuel:float):
	_total_fuel += fuel

func fuel_tank_removed(fuel:float):
	_total_fuel -= fuel

func set_launched():
	current_fuel = _total_fuel
	_launched = true

func _physics_process(_delta: float) -> void:
	if _launched:
		for node in _array_joints:
			if global_position.distance_to(node.global_position) > 1.0:
				explode()
		if _scoring_part:
			GVar.signal_bus.rocket_root_height_changed.emit(global_position.y)

func explode():
	if !_exploded:
		_exploded = true
		GVar.signal_bus.root_destroyed.emit()
		var new_particle:Node3D = PARTICLES_EXPLOSION.instantiate()
		GVar.active_scene.add_child(new_particle)
		new_particle.global_position = global_position
		call_deferred("queue_free")

func setup(new_parent:RigidBody3D,new_attached_socket:RocketSocketPoint,_mass:float):
	mass = _mass
	_parent = new_parent
	_attached_socket = new_attached_socket
	var direction_vec:Vector3 = Vector3(_attached_socket.global_position - _parent.global_position).normalized().round()
	var half_rocket_bounds:Vector3 = rocket_collision_shape.shape.size
	var position_mod:Vector3 = (direction_vec * half_rocket_bounds * 1.025)
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

func unfreeze():
	set_deferred("freeze",false)


func _on_body_shape_entered(_body_rid: RID, _body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	var node = shape_owner_get_owner(shape_find_owner(_local_shape_index))
	if node.has_method("explode"):
		node.explode()
		return
	if _body_shape_index == 0:
		explode()
		return


func _body_entered(_body:Node):
	pass
	#print("collision_2")
