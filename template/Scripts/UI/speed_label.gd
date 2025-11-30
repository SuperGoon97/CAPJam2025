extends Label

func _ready() -> void:
	GVar.signal_bus.meters_per_second_changed.connect(update_label)

func update_label(speed:float):
	text = "%0.2f m/s" % speed
