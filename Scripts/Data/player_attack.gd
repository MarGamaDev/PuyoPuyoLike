class_name PlayerAttack extends RefCounted

var chain: int
var blue: int
var red: int
var green: int
var yellow: int

static func create(chainSize: int, blueCount: int, redCount: int, greenCount: int, yellowCount : int) -> PlayerAttack:
	var instance = PlayerAttack.new()
	instance.chain = chainSize
	instance.blue = blueCount
	instance.red = redCount
	instance.green = greenCount
	instance.yellow = yellowCount
	return instance
