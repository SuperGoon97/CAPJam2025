class_name CameraController extends Node3D

@export var rotation_speed:float = 2.5
@export var rotation_angle:float = 90.0
@export var camera_distance_to_midpoint_tolerance = 0.1

@onready var camera_rotate_cool_off: Timer = $CameraRotateCoolOff

var desired_position:Vector3
var desired_rot:float = 0.0
var last_x:float = 0.0
var child_cam:RocketCamera

func _ready() -> void:
	if GVar.signal_bus == null:
		await GVar.scene_manager.game_ready
	GVar.signal_bus.rocket_part_added.connect(_rocket_part_added)
	GVar.signal_bus.rotate_cam_left.connect(_rotate_left_clicked)
	GVar.signal_bus.rotate_cam_right.connect(_rotate_right_clicked)
	child_cam = get_tree().get_first_node_in_group("MainCamera")
	var node = get_tree().get_first_node_in_group("ShipRoot")
	if node is RocketRoot:
		desired_position = node.global_position

func _physics_process(delta: float) -> void:
	var x_direction:float = Input.get_axis("Left","Right")
	var y_direction:float = Input.get_axis("Down","Up")
	if x_direction != 0:
		#print_rich("[color=orange]ROTATION START[/color]")
		if camera_rotate_cool_off.time_left == 0.0:
			if desired_rot + rotation_angle * x_direction > 180:
				desired_rot = -180
			elif desired_rot + rotation_angle * x_direction < -180:
				desired_rot = 180
			desired_rot += rotation_angle * x_direction
			last_x = x_direction
			camera_rotate_cool_off.start()

	if abs(rad_to_deg(rotation.y) - desired_rot) > 355:
		desired_rot = -desired_rot
	elif abs(rad_to_deg(rotation.y) - desired_rot) > 2.5:
		#print("rot y = " + str(rad_to_deg(rotation.y)))
		#print("desired rot = " + str(desired_rot))
		#print("rot difference = " + str(abs(rad_to_deg(rotation.y) - desired_rot)))
		#print_rich("[color=blue]=================[/color]")
		rotate(Vector3(0.0,1.0,0.0),rotation_speed * delta * last_x)
	elif rotation.y != deg_to_rad(desired_rot):
		rotation.y = deg_to_rad(desired_rot)

	if y_direction != 0:
		child_cam.position.y = clampf(child_cam.position.y + (y_direction * delta),0.0,INF)
	
	var _distance_to_midpoint = global_position.distance_to(desired_position)
	if  _distance_to_midpoint > camera_distance_to_midpoint_tolerance:
		global_position = global_position.move_toward(desired_position,delta * _distance_to_midpoint)

func _rotate_left_clicked():
	last_x = -1.0
	if camera_rotate_cool_off.time_left == 0.0:
		if desired_rot - rotation_angle < -180:
			desired_rot = 180
		desired_rot -= rotation_angle
		camera_rotate_cool_off.start()

func _rotate_right_clicked():
	last_x = 1.0
	if camera_rotate_cool_off.time_left == 0.0:
		if desired_rot + rotation_angle > 180:
			desired_rot = -180
		desired_rot += rotation_angle
		camera_rotate_cool_off.start()

func _rocket_part_added():
	desired_position = child_cam.get_center_point()
