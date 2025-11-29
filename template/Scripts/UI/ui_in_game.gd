extends Control

@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	GVar.signal_bus.rocket_launch.connect(_makeVisible)
	GVar.signal_bus.current_height_changed.connect(_heightChanged)
func _makeVisible() -> void:
	visible = true
	
func _heightChanged(score:float):
	label.text = str(int(round(score))) + "m"
