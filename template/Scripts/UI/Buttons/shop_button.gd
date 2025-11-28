class_name ShopButton extends ButtonBase

@export var rocket_resource:RocketPartResource

func _pressed() -> void:
	super()
	if GVar.build_manager.current_score >= rocket_resource.cost:
		GVar.build_manager.current_score -= rocket_resource.cost
		GVar.ui_manager.ui_main.add_child(MouseFollowingTextureRect.new(rocket_resource.icon))
		GVar.signal_bus.player_grabbed_rocket_part_from_shop.emit(rocket_resource)
