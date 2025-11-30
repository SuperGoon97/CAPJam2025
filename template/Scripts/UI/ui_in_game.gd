extends Control

@onready var label: Label = $HBoxContainer/Label
@onready var label_2: Label = $HBoxContainer/Label2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	GVar.signal_bus.rocket_launch.connect(_makeVisible)
	GVar.signal_bus.current_height_changed.connect(_heightChanged)
	GVar.signal_bus.new_rocket_created.connect(hide)
func _makeVisible() -> void:
	visible = true
	
func _heightChanged(score:float):
	label.text = str(int(round(score))) + "m"
	label_2.text = str(int(round(GVar.build_manager.highscore_height))) + "m"
