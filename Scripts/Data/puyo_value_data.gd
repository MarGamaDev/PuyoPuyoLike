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
