extends Control
signal on_data_submitted(attack : PlayerAttack)
var chain: int:
	get: 
		return int($"Chain Input".text)
var blue: int:
	get:
		return int($"Blue Input".text)
var red: int:
	get:
		return int($"Red Input".text)
var yellow: int:
	get:
		return int($"Yellow Input".text)
var green: int:
	get:
		return int($"Green Input".text)

func _ready() -> void:
	pass

func on_button_click() -> void:
	var attack = PlayerAttack.create(chain, blue, red, green, yellow)
	on_data_submitted.emit(attack)
	pass
