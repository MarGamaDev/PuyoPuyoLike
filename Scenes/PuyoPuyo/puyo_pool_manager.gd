extends Node2D

class_name PuyoPoolManager

var certain_relic_puyos : Array = []
@export var puyo_certain_interval = 3
var puyo_counter = 0

var puyo_pool : Array[Array] = []

func _ready():
	certain_relic_puyos = []
	initialize_puyo_pool()

func initialize_puyo_pool() -> void:
	for i in range(2, 6):
		puyo_pool.append([2, i])
	for i in range(3, 6):
		puyo_pool.append([3, i])
	for i in range(4, 6):
		puyo_pool.append([4, i])
	puyo_pool.append([5, 5])
	#print(puyo_pool)

func get_puyo_pair() -> Array:
	#var to_return = [randi_range(2, 5), randi_range(2, 5)]
	var to_return = puyo_pool.pick_random()
	puyo_counter += 1
	if puyo_counter >= puyo_certain_interval:
		for i in range(0, certain_relic_puyos.size()):
			to_return[i] = certain_relic_puyos[i]
		puyo_counter = 0
	return to_return

func add_certain_puyo(type : Puyo.PUYO_TYPE):
	if certain_relic_puyos.size() < 2:
		certain_relic_puyos.append(type)

func get_pool() -> Array[Array]:
	var new_array : Array[Array]= []
	for pair : Array in puyo_pool:
		new_array.append(pair.duplicate())
	return new_array

func change_puyo_pool(pair_to_change : Array, to_change_to : Array):
	#print("puyo pool before: ")
	#print(puyo_pool)
	var pair_index = puyo_pool.find(pair_to_change)
	puyo_pool[pair_index] = to_change_to
	#print("puyo pool changed: ")
	#print(puyo_pool)
