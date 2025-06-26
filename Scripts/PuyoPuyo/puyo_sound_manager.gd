extends Node2D

class_name PuyoSoundManager

@onready var sfx_player : PolyphonicAudioPlayer = $SFXPlayer

func set_volume(num : float):
	sfx_player.set_volume_db(linear_to_db(num))

func play_puyo_thud():
	sfx_player.set_volume_db(5)
	match randi_range(1,3):
		1:
			
			sfx_player.play_sound_effect_from_library("collide_1")
		2:
			sfx_player.play_sound_effect_from_library("collide_2")
		3:
			sfx_player.play_sound_effect_from_library("collide_3")

func play_puyo_pop():
	set_volume(0.8)
	match(randi_range(0, 3)):
		0:
			sfx_player.play_sound_effect_from_library("pop_1")
		1:
			sfx_player.play_sound_effect_from_library("pop_2")
		2:
			sfx_player.play_sound_effect_from_library("pop_3")
		3:
			sfx_player.play_sound_effect_from_library("pop_4")
