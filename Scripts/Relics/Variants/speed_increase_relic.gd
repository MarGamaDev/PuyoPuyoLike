extends BaseRelic

signal increase_speed(speed_mult: float)
signal increase_puyo_values(chain_mult : float, base_mult: float)

@export var speed_multiplier : float = 0.5
@export var chain_multiplier : float = 1.5
@export var base_multiplier : float = 1.3

func initialize() -> void:
	super()
	increase_puyo_values.connect(combat_manager.multiply_puyo_values)
	increase_speed.connect(puyo_manager.increase_player_tick_speed)
	increase_speed.emit(speed_multiplier)
	increase_puyo_values.emit(chain_multiplier, base_multiplier)
