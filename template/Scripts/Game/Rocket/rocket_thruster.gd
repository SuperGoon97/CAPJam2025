class_name RocketThurster extends RocketPart

@onready var thrust_point: Node3D = $ThrustPoint
@onready var rocket_root:RocketRoot = get_tree().get_first_node_in_group("ShipRoot")
@onready var thruster: ThrusterParticle = $Thruster
@onready var thruster_audio: AudioStreamPlayer3D = $ThrusterAudio

var _do_thrust:bool = false

func _ready() -> void:
	super()
	GVar.signal_bus.rocket_launch.connect(rocket_launch)

func _physics_process(delta: float) -> void:
	if _do_thrust:
		if rocket_root:
			if rocket_root.current_fuel >= resource_data.fuel_cost_per_delta * delta:
				if thruster_audio.playing == false: start_thruster_audio()
				thruster.start()
				rocket_root.apply_force(global_transform.basis.y * resource_data.thrust * delta,thrust_point.global_position)
				rocket_root.current_fuel -= resource_data.fuel_cost_per_delta * delta
			else:
				stop_thruster_audio()
				thruster.stop()

func start_thruster_audio():
	thruster_audio.play()
	thruster_audio.transition()

func stop_thruster_audio():
	thruster_audio.stop()

func rocket_launch():
	_do_thrust = true
	rocket_root = get_tree().get_first_node_in_group("ShipRoot")
