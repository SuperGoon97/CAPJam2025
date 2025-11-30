extends Control

@onready var label: Label = $ProgressBar/Label
@onready var rocket_root:RocketRoot = get_tree().get_first_node_in_group("ShipRoot")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GVar.signal_bus.physics_enabled.connect(_hideShopMenu)
	GVar.signal_bus.rocket_part_added.connect(_changeFuelCapacity)
	_changeFuelCapacity(null)
func _hideShopMenu() -> void:
	visible = false
	
func _changeFuelCapacity(_args) -> void:
	label.text = "Fuel: " + str(int(round(rocket_root._total_fuel))) + "L"
