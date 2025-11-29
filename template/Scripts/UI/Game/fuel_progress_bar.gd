extends ProgressBar

@onready var rocket_root:RocketRoot = get_tree().get_first_node_in_group("ShipRoot")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GVar.signal_bus.rocket_fuel_changed.connect(_onFuelChanged)
	value = 100
	
func _onFuelChanged(_current_fuel:float,fuel_percent:float):
	value = fuel_percent * 100
