extends AudioStreamPlayer3D

var play_back:AudioStreamPlaybackInteractive

func transition():
	play_back = get_stream_playback()
	play_back.switch_to_clip(1)
