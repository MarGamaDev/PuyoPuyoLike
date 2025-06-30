extends Node2D

class_name PuyoPoolManager

var puyos_to_add : Array = []
@export var puyo_certain_interval = 3
var puyo_counter = 0

func _ready():
	puyos_to_add = []

func get_puyo_pair() -> Array:
	var to_return = [randi_range(2, 5), randi_range(2, 5)]
	puyo_counter += 1
	if puyo_counter >= puyo_certain_interval:
		for i in range(0, puyos_to_add.size()):
			to_return[i] = puyos_to_add[i]
		puyo_counter = 0
	return to_return

func add_certain_puyo(type : Puyo.PUYO_TYPE):
	if puyos_to_add.size() < 2:
		puyos_to_add.append(type)
	#print(puyos_to_add)
	
