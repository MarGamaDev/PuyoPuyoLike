extends Node2D

@onready var lives_array : Array = [$Heart, $Heart2, $Heart3]
var current_lives = 3
@export var max_lives : int = 3

func set_lives_to(lives : int):
	current_lives = lives

func lose_a_life():
	if current_lives > 0:
		current_lives -= 1
	if current_lives < 3:
		lives_array[current_lives].hide()

func gain_a_life():
	current_lives += 1
	if current_lives < 3:
		lives_array[current_lives - 1].show()
