extends Node2D


func lose_life():
	print("life lost")
	

func chain_popped(type : Puyo.PUYO_TYPE, number_popped: int, chain_length: int):
	print("chain type: ", type, " with ", number_popped, " puyos, chain length ", chain_length)
