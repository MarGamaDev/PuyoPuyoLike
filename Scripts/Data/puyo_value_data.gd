class_name PuyoValueData
extends Resource
@export var green_base_value: int
@export var green_chain_multiplier: int
@export var red_base_value: int
@export var red_chain_multiplier: int
@export var yellow_base_value: int
@export var yellow_chain_multiplier: int
@export var blue_base_value: int
@export var blue_chain_multiplier: int

func get_multiplier(puyo_type: Puyo.PUYO_TYPE) -> int:
	match puyo_type:
		Puyo.PUYO_TYPE.BLUE:
			return blue_chain_multiplier
		Puyo.PUYO_TYPE.RED:
			return red_chain_multiplier
		Puyo.PUYO_TYPE.YELLOW:
			return yellow_chain_multiplier
		Puyo.PUYO_TYPE.GREEN:
			return green_chain_multiplier
		_:
			return 1

func get_base_value(puyo_type: Puyo.PUYO_TYPE) -> int:
	match puyo_type:
		Puyo.PUYO_TYPE.BLUE:
			return blue_base_value
		Puyo.PUYO_TYPE.RED:
			return red_base_value
		Puyo.PUYO_TYPE.YELLOW:
			return yellow_base_value
		Puyo.PUYO_TYPE.GREEN:
			return green_base_value
		_:
			return 1

func multiply_values(chain_mult:float, base_mult:float):
	green_base_value = ceil(base_mult * green_base_value)
	green_chain_multiplier = ceil(chain_mult * green_chain_multiplier)
	red_base_value = ceil(red_base_value * base_mult)
	red_chain_multiplier = ceil(red_chain_multiplier * chain_mult)
	yellow_base_value = ceil(yellow_base_value * base_mult)
	yellow_chain_multiplier = ceil(yellow_chain_multiplier * chain_mult)
	blue_base_value = ceil(blue_base_value * base_mult)
	blue_chain_multiplier = ceil(blue_chain_multiplier * chain_mult)
	pass
