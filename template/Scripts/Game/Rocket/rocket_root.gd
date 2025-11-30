class_name RocketRoot extends RigidBody3D

signal do_socket_overlap_check

const PARTICLES_EXPLOSION = preload("res://Assets/Particles/particles_explosion.tscn")

@export var starting_fuel:float = 100.0
@export var rand_deceleartion_force_mod:float = 5.0
var _parent:RigidBody3D = null
var _attached_socket:RocketSocketPoint
var _array_joints:Array[PinJoint3D]
var _scoring_part:bool = false
var _launched:bool = false
var _exploded:bool = false

@export_storage var _total_fuel:float = 0.0:
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

var rocket_speed:float = 0.0:
	set(value):
		rocket_speed = value
		GVar.signal_bus.meters_per_second_changed.emit(rocket_speed)
var last_frame_pos:Vector3 = Vector3(0.0,0.0,0.0)

var do_once_sold:bool = true
var do_once_increase_gravity:bool = true

var resource_data:RocketPartResource
@onready var rocket_collision_shape: CollisionShape3D = $RocketCollisionShape
@onready var rocket_socket_check_area: RocketArea3D = $RocketSocketCheckArea

func _ready() -> void:
	if !GVar.signal_bus:
		await GVar.scene_manager.game_ready
	GVar.signal_bus.rocket_tank_added.connect(fuel_tank_added)
	GVar.signal_bus.physics_enabled.connect(unfreeze)
	GVar.signal_bus.rocket_part_added.connect(new_rocket_part)
	GVar.signal_bus.rocket_part_sold.connect(rocket_part_sold)
	if is_in_group("ShipRoot"):
		_scoring_part = true
		GVar.signal_bus.rocket_launch.connect(set_launched)
		body_shape_entered.connect(_on_body_shape_entered)
		body_entered.connect(_body_entered)
	else:
		rocket_socket_check_area.area_left_clicked.connect(area_left_clicked)
		
	_total_fuel += starting_fuel

func new_rocket_part(data:RocketPartResource):
	mass += data.mass

func rocket_part_sold(rocket_part:RocketPart):
	mass -= rocket_part.resource_data.mass

func fuel_tank_added(fuel:float):
	_total_fuel += fuel

func fuel_tank_removed(fuel:float):
	_total_fuel -= fuel

func set_launched():
	current_fuel = _total_fuel
	_launched = true

func _physics_process(delta: float) -> void:
	if _launched:
		if roundf(current_fuel) == 0 and global_position.y < last_frame_pos.y and do_once_increase_gravity:
			set_deferred("gravity_scale",gravity_scale * 3)
			do_once_increase_gravity = false
		for node in _array_joints:
			if global_position.distance_to(node.global_position) > 1.0:
				explode()
		GVar.signal_bus.rocket_root_height_changed.emit(global_position.y)
		if !last_frame_pos == Vector3.ZERO:
			var distance_traveled = global_position.distance_to(last_frame_pos)
			var _temp_rocket_speed = distance_traveled/delta
			if _temp_rocket_speed < rocket_speed:
				apply_torque(Vector3(randf_range(-1.0,1.0) * rand_deceleartion_force_mod,randf_range(-1.0,1.0) * rand_deceleartion_force_mod,randf_range(-1.0,1.0) * rand_deceleartion_force_mod)*delta)
			rocket_speed = distance_traveled/delta
	last_frame_pos = global_position

func explode():
	if !_exploded:
		_exploded = true
		GVar.signal_bus.root_destroyed.emit()
		var new_particle:Node3D = PARTICLES_EXPLOSION.instantiate()
		GVar.active_scene.add_child(new_particle)
		new_particle.global_position = global_position
		GVar.signal_bus.rocket_bit_go_bang_bang.emit(global_position)
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
	if node:
		if node.has_method("explode"):
			node.explode()
			return
	if _body_shape_index == 0:
		explode()
		return


func _body_entered(_body:Node):
	pass
	#print("collision_2")
