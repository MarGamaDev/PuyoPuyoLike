extends Node2D

@onready var music_player : PolyphonicAudioPlayer = $MusicPlayer

func _ready():
	music_player.play_sound_effect_from_library("PuyoPuyoTheme_1")
