extends Resource
class_name AudioLibrary

@export var sound_effects: Array[SoundEffect]

func get_audio_stream(tag : String):
	var index = -1
	if tag:
		for sound in sound_effects:
			index += 1
			if sound.tag == tag:
				break
		return sound_effects[index].stream
	else:
		print("no tag provided")
	return null
