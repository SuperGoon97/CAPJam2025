class_name ShopButton extends ButtonBase

@export var rocket_resource:RocketPartResource
@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label


func _button_down() -> void:
	if GVar.build_manager.current_score >= rocket_resource.cost:
		GVar.ui_manager.ui_main.add_child(MouseFollowingTextureRect.new(rocket_resource.icon))
		GVar.signal_bus.player_grabbed_rocket_part_from_shop.emit(rocket_resource)

func _ready() -> void:
	super()
	texture_rect.texture = rocket_resource.icon
	label.text = ("$" + str(rocket_resource.cost))
	GVar.signal_bus.score_changed.connect(_changeTextScoreChanged)
	_changeTextScoreChanged(GVar.build_manager.current_score)
	
func _changeTextScoreChanged(score:int):
	if score >= rocket_resource.cost:
		label.add_theme_color_override("font_color", Color(0.0, 1.0, 0.0, 1.0))
	else:
		label.add_theme_color_override("font_color", Color(1.0, 0.0, 0.0, 1.0))
