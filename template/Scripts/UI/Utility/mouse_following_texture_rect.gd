class_name MouseFollowingTextureRect extends TextureRect

func _init(_texture:CompressedTexture2D):
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture = _texture
	GVar.signal_bus.rocket_part_added.connect(_destroy)
	GVar.signal_bus.player_right_click.connect(_destroy)

func _physics_process(_delta: float) -> void:
	global_position = get_global_mouse_position()

func _destroy():
	call_deferred("queue_free")
