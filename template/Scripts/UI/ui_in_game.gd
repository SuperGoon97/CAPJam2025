extends Control

@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	GVar.signal_bus.rocket_launch.connect(_makeVisible)
	GVar.signal_bus.score_changed.connect(_scoreChanged)
func _makeVisible() -> void:
	visible = true
	
func _scoreChanged(score:int):
	label.text = str(score)
