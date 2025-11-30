class_name RocketPartTank extends RocketPart

@export var fuel:float = 100.0

func _ready() -> void:
	super()
	GVar.signal_bus.rocket_tank_added.emit(fuel)

func area_left_clicked():
	var children:Array[Node] = get_children()
	for child in children:
		if child is RocketPart:
			return
	if do_once_sold:
		GVar.signal_bus.rocket_part_sold.emit(self)
		GVar.signal_bus.rocket_tank_removed.emit(fuel)
		do_once_sold = !do_once_sold
