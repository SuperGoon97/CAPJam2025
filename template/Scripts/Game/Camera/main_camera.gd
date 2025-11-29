class_name RocketCamera extends Camera3D

@export var z_pos_change_mod:float = 0.75

var max_pos_y:float = 0.0
var max_mpos_y:float = 0.0
var y_dif:float = 0.0
var max_pos_x:float = 0.0
var max_mpos_x:float = 0.0
var x_dif:float = 0.0
var max_pos_z:float = 0.0
var max_mpos_z:float = 0.0
var z_dif:float = 0.0

var root_rocket:RocketRoot = null

var _look_at_mode:bool = false
var _target_y:float = 0.0

@onready var default_position:Vector3 = position
@onready var _desired_z:float = default_position.z

func _ready() -> void:
	if GVar.signal_bus == null:
		await GVar.scene_manager.game_ready
		GVar.signal_bus.rocket_part_added.connect(recalculate_size)
		GVar.signal_bus.rocket_launch.connect(_rocket_launched)
	setup()

func _physics_process(delta: float) -> void:
	if position.z < _desired_z:
		var dif:float = _desired_z - position.z
		position.z += pow(dif,2.0) * delta
	if _look_at_mode:
		look_at(root_rocket.global_position)
		if root_rocket.global_position.y > global_position.y:
			_target_y = root_rocket.global_position.y
		if _target_y != global_position.y:
			var dist = _target_y - global_position.y
			global_position.y += dist * delta * 30.0

func setup():
	if root_rocket == null:
		while root_rocket == null:
			root_rocket = get_tree().get_first_node_in_group("ShipRoot")
			await get_tree().process_frame
	max_pos_y = root_rocket.global_position.y
	max_mpos_y = root_rocket.global_position.y
	max_pos_x = root_rocket.global_position.x
	max_mpos_x = root_rocket.global_position.x
	max_pos_z = root_rocket.global_position.z
	max_mpos_z = root_rocket.global_position.z

func recalculate_size():
	var array_rocket_parts:Array[Node3D] = get_rocket_part_array()
	for rocket in array_rocket_parts:
		if rocket.global_position.y > max_pos_y:
			max_pos_y = rocket.global_position.y
		elif rocket.global_position.y < max_mpos_y:
			max_mpos_y = rocket.global_position.y
		if rocket.global_position.x > max_pos_x:
			max_pos_x = rocket.global_position.x
		elif rocket.global_position.x < max_mpos_x:
			max_mpos_x = rocket.global_position.x
		if rocket.global_position.z > max_mpos_z:
			max_pos_z = rocket.global_position.z
		elif rocket.global_position.z < max_mpos_z:
			max_mpos_z = rocket.global_position.z
	
	#print(max_pos_y)
	#print(max_mpos_y)
	y_dif = absf(max_pos_y - max_mpos_y)
	x_dif = absf(max_pos_x - max_mpos_x)
	z_dif = absf(max_pos_z - max_mpos_z)
	
	#print("y_dif = " + str(y_dif))
	#print("x_dif = " + str(x_dif))
	#print("z_dif = " + str(z_dif))
	if y_dif > x_dif and y_dif > z_dif:
		_desired_z = default_position.z + (y_dif * z_pos_change_mod)
	elif x_dif > y_dif and x_dif > z_dif:
		_desired_z = default_position.z + (x_dif * z_pos_change_mod)
	else:
		_desired_z = default_position.z + (z_dif * z_pos_change_mod)

func _rocket_launched():
	_look_at_mode = true

func get_rocket_part_array() -> Array[Node3D]:
	var array_nodes:Array[Node] = get_tree().get_nodes_in_group("RocketPart")
	var array_rocket_parts:Array[Node3D]
	array_rocket_parts.assign(array_nodes)
	return array_rocket_parts

func get_center_point() -> Vector3:
	var ret_vector:Vector3
	var array_rocket_parts:Array[Node3D] = get_rocket_part_array()
	var cum_gpos:Vector3 = Vector3 (0.0,0.0,0.0)
	for _node_3d in array_rocket_parts:
		cum_gpos += _node_3d.global_position
	ret_vector = cum_gpos / array_rocket_parts.size()
	return ret_vector
