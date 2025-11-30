class_name RocketPart extends CollisionShape3D

const PARTICLES_EXPLOSION = preload("res://Assets/Particles/particles_explosion.tscn")

signal do_socket_overlap_check
signal data_set

var do_once_sold:bool = true
var resource_data:RocketPartResource:
	set(value):
		resource_data = value
		data_set.emit()
var _exploded:bool = false
@onready var rocket_socket_check_area: RocketArea3D = $RocketSocketCheckArea
@export var prefered_socket:RocketSocketPoint

func _ready() -> void:
	if !GVar.signal_bus:
		await GVar.scene_manager.game_ready
	rocket_socket_check_area.area_left_clicked.connect(area_left_clicked)
	GVar.signal_bus.root_destroyed.connect(become_independant)

func explode():
	if !_exploded:
		_exploded = true
		var new_particle:Node3D = PARTICLES_EXPLOSION.instantiate()
		GVar.active_scene.add_child(new_particle)
		new_particle.global_position = global_position
		call_deferred("queue_free")


func setup(attached_socket:RocketSocketPoint):
	var temp_pos = attached_socket.get_parent().global_position
	var direction_vec:Vector3 = Vector3(attached_socket.global_position - temp_pos).normalized().round()
	var half_rocket_bounds:Vector3
	if shape is BoxShape3D:
		half_rocket_bounds = shape.size
	else:
		half_rocket_bounds = Vector3(shape.height,shape.height,shape.height)
	var position_mod:Vector3 = (direction_vec * half_rocket_bounds * 1.025)
	if prefered_socket:
		var dir_socket:Vector3 = Vector3(prefered_socket.global_position - global_position).normalized().round()
		var cross_product:Vector3 = direction_vec.cross(dir_socket)
		var angle_to:float = dir_socket.angle_to(direction_vec)
		#var rot_quat:Quaternion = Quaternion(cross_product,angle_to)
		if cross_product != Vector3.ZERO:
			rotate(cross_product.normalized(),angle_to)
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
		socket.set_socket_enabled(false)
	do_socket_overlap_check.emit()

func area_left_clicked():
	var children:Array[Node] = get_children()
	var socket_array:Array[RocketSocketPoint]
	var n_sockets_bound:int = 0
	for child in children:
		if child is RocketSocketPoint:
			socket_array.push_back(child)
	for socket in socket_array:
		if socket.socket_bound:
			n_sockets_bound +=1
	if n_sockets_bound > 1:
		return
	if do_once_sold:
		GVar.signal_bus.rocket_part_sold.emit(self)
		do_once_sold = !do_once_sold

func become_independant():
	var new_parent:RigidBody3D = RigidBody3D.new()
	GVar.scene_manager.current_scene.add_child(new_parent)
	new_parent.global_position = global_position
	reparent(new_parent)
	new_parent.contact_monitor = true
	new_parent.max_contacts_reported = 4
	await get_tree().process_frame
	new_parent.body_entered.connect(_body_entered)

func _body_entered(_body:Node):
	print("bingbang")
	explode()
