class_name RocketThurster extends RocketPart

@onready var thrust_point: Node3D = $ThrustPoint
@onready var rocket_root:RocketRoot = get_tree().get_first_node_in_group("ShipRoot")
@onready var thruster: ThrusterParticle = $Thruster

var _do_thrust:bool = false

func _ready() -> void:
	super()
	GVar.signal_bus.rocket_launch.connect(rocket_launch)

func _physics_process(delta: float) -> void:
	if _do_thrust:
		if rocket_root:
			if rocket_root.current_fuel >= resource_data.fuel_cost_per_delta * delta:
				thruster.start()
				rocket_root.apply_force(global_transform.basis.y * resource_data.thrust * delta,thrust_point.global_position)
				rocket_root.current_fuel -= resource_data.fuel_cost_per_delta * delta
			else:
				thruster.stop()

func rocket_launch():
	_do_thrust = true
	rocket_root = get_tree().get_first_node_in_group("ShipRoot")
