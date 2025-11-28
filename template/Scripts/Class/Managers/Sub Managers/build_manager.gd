class_name BuildManager extends ManagerBase

@export var starting_score:int = 10000

var _hovered_socket:RocketSocketPoint
var _player_held_rocket_bit:RocketPartResource


var max_score:int:
	set(value):
		current_score += value - max_score
		max_score = value

var current_score:int

func _game_ready():
	GVar.signal_bus.mouse_entered_socket.connect(mouse_over_socket)
	GVar.signal_bus.mouse_exited_socket.connect(mouse_exit_socket)
	GVar.signal_bus.socket_clicked.connect(socket_clicked)
	GVar.signal_bus.player_grabbed_rocket_part_from_shop.connect(set_player_held_rocket_bit)
	GVar.signal_bus.rocket_part_added.connect(set_player_held_rocket_bit.bind(null))
	GVar.signal_bus.player_right_click.connect(right_click_handler)
	max_score += starting_score
	pass


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
		socket_parent.add_child(new_rocket_part)
		new_rocket_part.owner = get_tree().get_first_node_in_group("ShipRoot")
		new_rocket_part.setup(socket_parent,socket)
		GVar.signal_bus.rocket_part_added.emit()

func right_click_handler():
	if _player_held_rocket_bit:
		current_score += _player_held_rocket_bit.cost
		set_player_held_rocket_bit(null)

func set_player_held_rocket_bit(rocket_bit:RocketPartResource):
	_player_held_rocket_bit = rocket_bit
