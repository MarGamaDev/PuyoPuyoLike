extends AudioStreamPlayer2D

class_name PolyphonicAudioPlayer

@export var audio_library : AudioLibrary
@export var custom_max_polyphony : int = 32

func _ready():
	stream = AudioStreamPolyphonic.new()
	stream.polyphony = custom_max_polyphony

func play_sound_effect_from_library(tag: String) -> void:
	if tag:
		var audio_stream = audio_library.get_audio_stream(tag)
		if !playing:
			self.play()
		var polyphonic_stream_playback = self.get_stream_playback()
		polyphonic_stream_playback.play_stream(audio_stream)
	else:
		print("no tag provided")
