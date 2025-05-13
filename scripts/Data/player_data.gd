extends Node

var puyo_pool : Array[Array] = []

func _ready() -> void:
	#adding all combos with blue, then green, e.c.t
	for i in range(2, 6):
		puyo_pool.append([2, i])
	for i in range(3, 6):
		puyo_pool.append([3, i])
	for i in range(4, 6):
		puyo_pool.append([4, i])
	puyo_pool.append([5, 5])

func get_puyo_pool() -> Array[Array]:
	return puyo_pool
