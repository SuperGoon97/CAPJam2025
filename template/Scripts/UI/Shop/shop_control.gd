extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GVar.signal_bus.physics_enabled.connect(_hideShopMenu)


func _hideShopMenu() -> void:
	visible = false
