extends Spatial

func _ready():
	randomize()

func play(audio_string):
	var audio = get_node_or_null(audio_string)
	if not audio:
		assert("Audio " + audio_string + " does not exist")
	audio.playing = true

func play_rand_pitch(audio_string):
	var audio = get_node_or_null(audio_string)
	if not audio:
		assert("Audio " + audio_string + " does not exist")
	audio.pitch_scale = rand_range(0.8, 1.2)
	audio.playing = true
