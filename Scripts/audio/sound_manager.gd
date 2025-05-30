extends Node2D

@onready var sfx_player : PolyphonicAudioPlayer = $SFXPlayer

var zen_song_1_path : String = "res://Audio/Music/zen_song_1_looping.mp3"

var enemy_attack_sound_flag : bool = true

func _ready():
	#music_player.play_sound_effect_from_library("PuyoPuyoTheme_1")
	var current_song : AudioStreamMP3 = load(zen_song_1_path)
	$MusicPlayer.set_stream(current_song)
	$MusicPlayer.play(0)

func life_lost_sfx():
	sfx_player.play_sound_effect_from_library("life_loss")

func enemy_attack_sfx(unused_attack, unused_enemy):
	if enemy_attack_sound_flag:
		enemy_attack_sound_flag = false
		$EnemyAudioTimer.start()
		match randi_range(1, 3):
			1:
				sfx_player.play_sound_effect_from_library("enemy_attack_1")
			2:
				sfx_player.play_sound_effect_from_library("enemy_attack_2")
			3:
				sfx_player.play_sound_effect_from_library("enemy_attack_3")


func _on_enemy_audio_timer_timeout() -> void:
	enemy_attack_sound_flag = true
