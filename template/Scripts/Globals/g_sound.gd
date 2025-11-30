extends Node

signal got_main_camera()

const NICE_SHOT_WII_SPORTS = preload("uid://dwml40ol2gxnc")
const ACIDJAZZ_2_LOOPED_MUSIC = preload("uid://cxracajq2rq4g")

var main_camera:Camera3D

func play_sound(_bus : StringName, _sound : AudioStream, ..._args : Array) -> void:
	return

func play_sound_main_camera(sound:AudioStream,bus):
	get_camera()
	var new_audio_player:AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	new_audio_player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_DISABLED
	main_camera.add_child(new_audio_player)
	new_audio_player.stream = sound
	new_audio_player.bus = bus
	new_audio_player.pitch_scale = randf_range(new_audio_player.pitch_scale-0.5,new_audio_player.pitch_scale)
	new_audio_player.play(0.0)
	new_audio_player.finished.connect(new_audio_player.queue_free)

func play_sound3D_at_location(sound:AudioStream,location:Vector3,bus):
	print("bang")
	var new_audio_player:AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	GVar.active_scene.add_child(new_audio_player)
	new_audio_player.unit_size = 100
	new_audio_player.global_position = location
	new_audio_player.stream = sound
	new_audio_player.bus = bus
	new_audio_player.pitch_scale = randf_range(new_audio_player.pitch_scale-0.5,new_audio_player.pitch_scale)
	new_audio_player.play(0.0)
	new_audio_player.finished.connect(new_audio_player.queue_free)
	
func play_music_main_camera(sound:AudioStream,bus):
	get_camera()
	await got_main_camera
	var new_audio_player:AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	new_audio_player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_DISABLED
	main_camera.add_child(new_audio_player)
	new_audio_player.bus = bus
	new_audio_player.stream = sound
	new_audio_player.play()


func get_camera():
	while (main_camera == null):
		main_camera = get_tree().get_first_node_in_group("MainCamera")
		await get_tree().process_frame
	#if main_camera.tree_exiting.is_connected(main_camera_changing) == false:
		#main_camera.tree_exiting.connect(main_camera_changing)
	got_main_camera.emit()

#func main_camera_changing():
	#active_playback = active_music_player.stream
	#stream_position = active_music_player.get_playback_position()
	#await get_tree().process_frame
	#play_music_main_camera()
