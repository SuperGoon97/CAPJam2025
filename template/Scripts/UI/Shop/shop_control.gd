extends Control

@onready var label: Label = $ProgressBar/Label
@onready var rocket_root:RocketRoot = get_rocket_root()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GVar.signal_bus.physics_enabled.connect(_hideShopMenu)
	GVar.signal_bus.rocket_part_added.connect(_changeFuelCapacity)
	GVar.signal_bus.new_rocket_created.connect(show)
	_changeFuelCapacity(null)

func _hideShopMenu() -> void:
	visible = false
	
func _changeFuelCapacity(_args) -> void:
	if !rocket_root:
		rocket_root = get_rocket_root()
	label.text = "Fuel: " + str(int(round(rocket_root._total_fuel))) + "L"

func get_rocket_root() -> Node:
	return get_tree().get_first_node_in_group("ShipRoot")
