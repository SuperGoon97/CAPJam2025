class_name RocketThurster extends RocketBase

@onready var thrust_point: Node3D = $ThrustPoint

@export var thrust_force:float = 5000.0
var _do_thrust:bool = false

func _ready() -> void:
	super()
	GVar.signal_bus.rocket_launch.connect(rocket_launch)

func _physics_process(delta: float) -> void:
	if _do_thrust:
		print(basis.y)
		apply_force(basis.y * thrust_force * delta,thrust_point.global_position)

func rocket_launch():
	_do_thrust = true
	pass
