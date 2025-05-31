extends Node2D
class_name SoundManager

@onready var sfx_player : PolyphonicAudioPlayer = $SFXPlayer

@export var song_volume : float = 0
@export var non_puyo_sfx_volume : float = 0
var rest_count = 0
@export var song_change_rest_count : int = 3

var zen_song_1_path : String = "res://Audio/Music/zen_song_1_looping.mp3"
var zen_song_2_path : String = "res://Audio/Music/zen_song_2.mp3"
var marshall_song_1_path : String = "res://Audio/Music/marshall_song_1_looping.mp3"

var current_path : String

var enemy_attack_sound_flag : bool = true

var fadein_flag = false

var current_player : AudioStreamPlayer
var selected_song = 0

func _ready():
	$MarshallSong.set_volume_db(-25)
	$ZenSong1.set_volume_db(-19)
	$ZenSong2.set_volume_db(-25)
	#music_player.play_sound_effect_from_library("PuyoPuyoTheme_1")
	match randi_range(0,1):
		0:
			current_player = $MarshallSong
			selected_song = 0
		1:
			current_player = $ZenSong1
			selected_song = 1
		2:
			current_player = $ZenSong2
			selected_song = 2
	current_player.play(0)
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


var next_song : int

func _on_rest_stop() -> void:
	rest_count += 1
	if rest_count == song_change_rest_count:
		rest_count = 0
		if selected_song == 0:
			next_song = 1
		else:
			next_song = 0
		if next_song == selected_song:
			return
		var next_player
		match selected_song:
			0:
				$MarshallSong/AnimationPlayer.play("marshall_fade_out")
			1:
				$ZenSong1/AnimationPlayer.play("zen_1_fadeout")
			2:
				$ZenSong2/AnimationPlayer.play("zen_2_fadeout")
		selected_song = next_song
		match next_song:
			0:
				next_player = $MarshallSong
				$MarshallSong/AnimationPlayer.play("marshall_fade_in")
			1:
				next_player = $ZenSong1
				$ZenSong1/AnimationPlayer.play("zen_1_fadein")
			2:
				next_player = $ZenSong2
				$ZenSong2/AnimationPlayer.play("zen_2_fadeout")
		next_player.play(0)
		await get_tree().create_timer(2).timeout
		current_player.stop()
		current_player = next_player
		selected_song = next_song
	#pass # Replace with function body.

var relic_ding_flag = true

func relic_ding_play():
	print("ding")
	if relic_ding_flag:
		sfx_player.play_sound_effect_from_library("relic_ding")
		relic_ding_flag = false
		await get_tree().create_timer(0.15).timeout
		relic_ding_flag = true

func spell_build_up_play():
	sfx_player.play_sound_effect_from_library("spell_build_up")


func _on_player_on_attack_blocked(damage_blocked: int, shield_before_damage: int) -> void:
	sfx_player.play_sound_effect_from_library("attack_blocked")


func _on_player_on_counter_triggered(counter_amount: int) -> void:
	sfx_player.play_sound_effect_from_library("attack_countered")


var enemy_death_sound = true

func _on_combat_on_enemy_deregistered(enemy: Enemy) -> void:
	if enemy_death_sound == true:
		enemy_death_sound = false
		sfx_player.play_sound_effect_from_library("enemy_death")
		await get_tree().create_timer(1.5).timeout
		enemy_death_sound = true
	pass # Replace with function body.
