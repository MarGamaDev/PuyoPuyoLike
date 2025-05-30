extends Node2D

@onready var sfx_player : PolyphonicAudioPlayer = $SFXPlayer

var zen_song_1_path : String = "res://Audio/Music/zen_song_1_looping.mp3"

func _ready():
	#music_player.play_sound_effect_from_library("PuyoPuyoTheme_1")
	var current_song : AudioStreamMP3 = load(zen_song_1_path)
	$MusicPlayer.set_stream(current_song)
	$MusicPlayer.play(0)

func life_lost_sfx():
	sfx_player.play_sound_effect_from_library("life_loss")
