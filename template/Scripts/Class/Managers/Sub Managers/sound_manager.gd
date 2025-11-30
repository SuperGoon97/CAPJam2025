class_name SoundManager extends ManagerBase

const ITEM_SHOP__1_ = preload("res://Assets/Audio/AudioFiles/Music/Item Shop (1).mp3")
const SND_SHIP_EXPLODE = preload("uid://bigkqt364c7wt")


func _game_ready():
	GVar.signal_bus.player_grabbed_rocket_part_from_shop.connect(_player_grabbed_part)
	GVar.signal_bus.rocket_part_sold.connect(_player_discarded_part)
	GVar.signal_bus.rocket_part_added.connect(_player_added_part)
	GVar.signal_bus.rocket_bit_go_bang_bang.connect(bang)
	_play_music()

func _player_grabbed_part(rocket_part:RocketPartResource):
	#var audio_stream:AudioStreamMP3 = load(rocket_part.pickup_sound.resource_path)
	GSound.play_sound_main_camera(rocket_part.pickup_sound,&"SFX")

func _player_discarded_part(rocket_part:RocketPart):
	GSound.play_sound_main_camera(rocket_part.resource_data.discard_sound,&"SFX")

func _player_added_part(rocket_part:RocketPartResource):
	GSound.play_sound_main_camera(rocket_part.place_sound,&"SFX")

func _play_music():
	GSound.play_music_main_camera(ITEM_SHOP__1_,&"Music")

func bang(position:Vector3):
	GSound.play_sound3D_at_location(SND_SHIP_EXPLODE,position,&"SFX")
