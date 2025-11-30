extends MultiMeshInstance3D

const TREE_GRADIENT:GradientTexture1D = preload("res://Scripts/Resources/Gradients/tree_gradient.tres")


@export var mesh_scene: Mesh
@export var instance_count: int = 100
@export var spawn_radius:float = 20.0
@export var inner_clearance:float = 10.0
func _ready() -> void:
	multimesh = MultiMesh.new()
	multimesh.use_colors = true
	multimesh.mesh = mesh_scene
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = instance_count
	
	for i in multimesh.instance_count:
		multimesh.set_instance_color(i,TREE_GRADIENT.gradient.sample(randf_range(0.0,1.0)))
		var rand_position:Vector3 = Vector3(randf_range(-spawn_radius,spawn_radius)+inner_clearance,0.0,randf_range(-spawn_radius,spawn_radius)+inner_clearance)
		var rand_rot:Basis = Basis(Vector3.UP ,randf_range(0.0,2*PI))
		var rand_scale:Vector3 = Vector3.ONE * randf_range(0.75,1.5)
		var transform:Transform3D = Transform3D(rand_rot,rand_position)
		transform = transform.scaled(rand_scale)
		multimesh.set_instance_transform(i,transform)
