class_name CameraController extends Node3D

@export var rotation_speed:float = 1.0

func _physics_process(delta: float) -> void:
	var x_direction:float = Input.get_axis("Left","Right")
	var y_direction:float = Input.get_axis("Down","Up")

	if x_direction != 0:
		rotate(Vector3(0.0,1.0,0.0),rotation_speed * delta * x_direction)
	if y_direction != 0:
		position.y = clampf(position.y + (y_direction * delta),0.0,INF)
