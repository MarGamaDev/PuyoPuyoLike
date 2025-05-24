extends Node

var puyo_pool : Array[Array] = []


#enum PUYO_TYPE {UNDEFINED 0, JUNK 1 , BLUE 2 , GREEN 3, RED 4, YELLOW 5}
signal puyo_pool_changed

func _ready() -> void:
	#adding all combos with blue, then green, e.c.t
	initialize_puyo_pool()

func initialize_puyo_pool() -> void:
	for i in range(2, 6):
		puyo_pool.append([2, i])
	for i in range(3, 6):
		puyo_pool.append([3, i])
	for i in range(4, 6):
		puyo_pool.append([4, i])
	puyo_pool.append([5, 5])

func get_puyo_pool() -> Array[Array]:
	return puyo_pool

func remove_pair(pair_to_remove : Array[int]):
	puyo_pool.erase(pair_to_remove)

func add_pair(pair_to_add : Array[int]):
	puyo_pool.append(pair_to_add)
