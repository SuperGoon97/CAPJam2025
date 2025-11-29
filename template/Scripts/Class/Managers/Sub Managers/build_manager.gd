class_name BuildManager extends ManagerBase

@export var starting_score:int = 10000
@export var height_to_money_ratio:float = 10.0
var _hovered_socket:RocketSocketPoint
var _player_held_rocket_bit:RocketPartResource

var highscore_height:float = 0.0:
	set(value):
		highscore_height = value
		highscore_height_int = roundi(highscore_height)

var highscore_height_int:int = 0:
	set(value):
		max_score += abs(highscore_height_int - value)
		highscore_height_int = value
		print_rich("[color=gold] new highscore height = "+ str(highscore_height_int) + "[/color]")

var current_height:float = 0.0:
	set(value):
		current_height = value
		if current_height > highscore_height:
			highscore_height = current_height

var max_score:int:
	set(value):
		current_score += value - max_score
		max_score = value
		print("[color=orange] new maxscore = " + str(max_score) + "[/color]")

var current_score:int:
	set(value):
		current_score = value
		GVar.signal_bus.score_changed.emit(current_score)

func _game_ready():
	GVar.signal_bus.mouse_entered_socket.connect(mouse_over_socket)
	GVar.signal_bus.mouse_exited_socket.connect(mouse_exit_socket)
	GVar.signal_bus.socket_clicked.connect(socket_clicked)
	GVar.signal_bus.player_grabbed_rocket_part_from_shop.connect(set_player_held_rocket_bit)
	GVar.signal_bus.rocket_part_added.connect(set_player_held_rocket_bit.bind(null))
	GVar.signal_bus.player_right_click.connect(right_click_handler)
	GVar.signal_bus.rocket_root_height_changed.connect(set_current_height)
	max_score += starting_score
	pass

func set_current_height(value:float):
	current_height = value

func mouse_over_socket(socket:RocketSocketPoint):
	_hovered_socket = socket
	pass

func mouse_exit_socket():
	_hovered_socket = null
	pass

func socket_clicked(socket:RocketSocketPoint):
	if _player_held_rocket_bit:
		var scene_path:String = _player_held_rocket_bit.scene_path_string
		var scene:PackedScene = load(scene_path)
		var new_rocket_part:RocketBase = scene.instantiate()
		var socket_parent:RigidBody3D = socket.get_parent()
		current_score -= _player_held_rocket_bit.cost
		socket_parent.add_child(new_rocket_part)
		new_rocket_part.owner = get_tree().get_first_node_in_group("ShipRoot")
		new_rocket_part.setup(socket_parent,socket,_player_held_rocket_bit.mass)
		GVar.signal_bus.rocket_part_added.emit()

func right_click_handler():
	if _player_held_rocket_bit:
		set_player_held_rocket_bit(null)

func left_click_released_handler():
	if _player_held_rocket_bit:
		set_player_held_rocket_bit(null)

func set_player_held_rocket_bit(rocket_bit:RocketPartResource):
	_player_held_rocket_bit = rocket_bit
