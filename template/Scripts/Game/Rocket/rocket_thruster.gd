class_name RocketThurster extends RocketPart

@onready var thrust_point: Node3D = $ThrustPoint
@onready var rocket_root:RocketRoot = get_tree().get_first_node_in_group("ShipRoot")
@export var thrust_force:float = 1000.0
@export var fuel_cost_per_delta:float = 0.5
var _do_thrust:bool = false

func _ready() -> void:
	super()
	GVar.signal_bus.rocket_launch.connect(rocket_launch)

func _physics_process(delta: float) -> void:
	if _do_thrust:
		if rocket_root.current_fuel >= fuel_cost_per_delta:
			rocket_root.apply_force(global_transform.basis.y * thrust_force * delta,thrust_point.global_position)
			rocket_root.current_fuel -= fuel_cost_per_delta

func rocket_launch():
	_do_thrust = true
