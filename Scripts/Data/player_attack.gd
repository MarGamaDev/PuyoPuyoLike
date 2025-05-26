class_name PlayerAttack extends Node

var chain: int
var size: int
var type: Puyo.PUYO_TYPE

#gets an array of gridnodes
static func create(puyo_block : Array, chain_value : int):
	var instance = PlayerAttack.new()
	instance.chain = chain_value
	instance.type = puyo_block[0].puyo.puyo_type
	instance.size = puyo_block.size()
	return instance

static func create_manually(puyo_number : int, puyo_type : Puyo.PUYO_TYPE, chain_value : int):
	var instance = PlayerAttack.new()
	instance.chain = chain_value
	instance.type = puyo_type
	instance.size = puyo_number
	return instance
