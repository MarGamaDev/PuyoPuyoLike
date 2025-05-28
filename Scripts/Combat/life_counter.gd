extends Node2D

@onready var lives_array : Array[AnimatedSprite2D] = [$Heart, $Heart2, $Heart3]
@onready var lives_animation_players: Array[AnimationPlayer] = [$Heart/AnimationPlayer, $Heart2/AnimationPlayer2, $Heart3/AnimationPlayer3]
@onready var lives_animation_names: Array[String] = ["Beat", "Beat2", "Beat3"]
var current_lives = 3
@export var max_lives : int = 3

signal trigger_heart_effect(position : Vector2)

func _ready() -> void:
	for i in range(0, 3):
		lives_animation_players[i].play(lives_animation_names[i])
	#$Heart/AnimationPlayer.play("Beat")
	#$Heart2/AnimationPlayer2.play("Beat2")
	#$Heart3/AnimationPlayer3.play("Beat3")

func set_lives_to(lives : int):
	current_lives = lives

func lose_a_life():
	if current_lives > 0:
		current_lives -= 1
		trigger_heart_effect.emit(lives_array[current_lives].global_position)
	if current_lives < 3:
		lives_array[current_lives].frame = 1
		lives_animation_players[current_lives].stop()

func gain_a_life():
	current_lives += 1
	if current_lives < 3:
		lives_array[current_lives - 1].frame = 0
		lives_animation_players[current_lives - 1].play(lives_animation_names[current_lives - 1])
