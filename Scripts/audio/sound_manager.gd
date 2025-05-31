extends Node2D
class_name SoundManager

@onready var sfx_player : PolyphonicAudioPlayer = $SFXPlayer

@export var song_volume : float = 0
@export var non_puyo_sfx_volume : float = 0
var rest_count = 0
@export var song_change_rest_count : int = 1

var zen_song_1_path : String = "res://Audio/Music/zen_song_1_looping.mp3"
var marshall_song_1_path : String = "res://Audio/Music/marshall_song_1_looping.mp3"

var current_path : String

var enemy_attack_sound_flag : bool = true

var fadein_flag = false

func _ready():
	#music_player.play_sound_effect_from_library("PuyoPuyoTheme_1")
	var current_song : AudioStreamMP3 
	match randi_range(0,1):
		0:
			current_path = marshall_song_1_path
			$MusicPlayer.set_volume_db(linear_to_db(song_volume - 0.07))
		1:
			current_path = zen_song_1_path
			$MusicPlayer.set_volume_db(linear_to_db(song_volume + 0.04))
	current_song = load(current_path)
	$MusicPlayer.set_stream(current_song)
	$MusicPlayer.play(0)
	$SFXPlayer.set_volume_db(linear_to_db(non_puyo_sfx_volume))

func life_lost_sfx():
	print("life lost sfx")
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

func transition_sfx(unused_encounter):
	sfx_player.play_sound_effect_from_library("encounter_transition")

func cast_spell_sfx(spell_length : int, spell_name : String):
	sfx_player.play_sound_effect_from_library("spell_cast")

func _on_enemy_audio_timer_timeout() -> void:
	enemy_attack_sound_flag = true


func _on_rest_stop() -> void:
	rest_count += 1
	#if rest_count == song_change_rest_count:
		#$fader.play("fadeout")
		#rest_count = 0
		#if current_path == marshall_song_1_path:
			#current_path = zen_song_1_path
		#elif current_path == zen_song_1_path:
			#current_path == marshall_song_1_path
		#$MusicPlayer.set_stream(load(current_path))
		#fadein_flag = true
	#pass # Replace with function body.

func _on_fader_animation_finished(anim_name: StringName) -> void:
	#if fadein_flag:
		#$MusicPlayer.play(0)
		#$fader.play("fadein")
		#fadein_flag = false
	pass

func relic_ding_play():
	print("ding")
	#sfx_player.play_sound_effect_from_library("relic_ding")
