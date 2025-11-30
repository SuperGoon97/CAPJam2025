extends Node3D

var camera_shake_amplitude:float = 1.0:
	get:
		return camera_shake_amplitude
	set(value):
		camera_shake_amplitude = value
## Camera shake strength, this value affects the offset strength alot so keep it small
var camera_shake_strength:float = 0.0
## Power value for camera shake strength
var camera_shake_strength_pow:float = 2.0
## Rate that camera shake is reduced
var camera_shake_decay:float = 0.5:
	get:
		return camera_shake_decay
	set(value):
		camera_shake_decay = value
## How jittery the camera shake is
var camera_shake_noise_speed:float = 50.0
## Progression of y point for sampling noise texture
var camera_shake_noise_y:float = 0.0
## If camera shake should only affect x axis
var camera_shake_x:bool = true
## If camera shake should only affect y axis
var camera_shake_y:bool = true
## Camera shake warm up value between 0.0 - 1.0
var camera_shake_warm_up:float = 0.0
## How quickly camera will reach max shake
var camera_warm_up_rate:float = 10.0
@onready var camera_perlin_noise:FastNoiseLite = FastNoiseLite.new()

func _ready() -> void:
	await GVar.scene_manager.game_ready
	_setup_camera_noise()
	#GVar.signal_bus.rocket_fuel_changed.connect(rocket_launched)
	GVar.signal_bus.rocket_bit_go_bang_bang.connect(rocket_bang)

func _physics_process(delta: float) -> void:
	if camera_shake_strength > 0.0:
		camera_shake_strength = max(camera_shake_strength - camera_shake_decay * delta,0.0)
		camera_shake_warm_up = min(camera_shake_warm_up + camera_warm_up_rate * delta ,1.0)
		camera_shake_noise_y += (camera_shake_noise_speed * (1.0 / (camera_shake_strength+ 0.1)))*delta
		_camera_shake()
		if camera_shake_strength == 0.0:
			camera_shake_warm_up = 0.0


#func rocket_launched(..._args):
	#if camera_shake_strength >= 1.5 : return
	#add_camera_shake()
func rocket_bang(..._args):
	add_camera_shake()

func add_camera_shake(strength:float = 2.0,strength_pow:float = 2.0,decay_rate:float = 0.5):
	camera_shake_strength = strength
	camera_shake_strength_pow = strength_pow
	camera_shake_decay = decay_rate

func _camera_shake():
	var strength = pow(camera_shake_strength,camera_shake_strength_pow)
	if camera_shake_x:
		position.x = (camera_shake_amplitude * strength * _sample_camera_noise(Vector2(camera_perlin_noise.seed,camera_shake_noise_y))* camera_shake_warm_up)
	if camera_shake_y:
		position.y = (camera_shake_amplitude * strength * _sample_camera_noise(Vector2(camera_perlin_noise.seed*2.0,camera_shake_noise_y))* camera_shake_warm_up)

func _sample_camera_noise(sample_position:Vector2) -> float:
	return camera_perlin_noise.get_noise_2d(sample_position.x,sample_position.y)

func _setup_camera_noise():
	camera_perlin_noise.set("noise_type",3)
	camera_perlin_noise.set("seed",randi() % 1000 + 1)
