extends Node2D

@onready var lives_array : Array[AnimatedSprite2D] = [$Heart, $Heart2, $Heart3]
@onready var lives_animations: Array[AnimationPlayer] = [$Heart/AnimationPlayer, $Heart2/AnimationPlayer2, $Heart3/AnimationPlayer3]
var current_lives = 3
@export var max_lives : int = 3

func _ready() -> void:
	for i in lives_animations:
		i.play("beat")

func set_lives_to(lives : int):
	current_lives = lives

func lose_a_life():
	if current_lives > 0:
		current_lives -= 1
	if current_lives < 3:
		lives_array[current_lives].frame = 1
		lives_animations[current_lives].stop()

func gain_a_life():
	current_lives += 1
	if current_lives < 3:
		lives_array[current_lives - 1].frame = 0
