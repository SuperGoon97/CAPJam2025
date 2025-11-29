extends Label

@onready var shopScore:int = GVar.build_manager.current_score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GVar.signal_bus.score_changed.connect(_changeTextScoreChanged)
	_changeTextScoreChanged(GVar.build_manager.current_score)


func _changeTextScoreChanged(score:int):
	text = ("$" + str(score))
