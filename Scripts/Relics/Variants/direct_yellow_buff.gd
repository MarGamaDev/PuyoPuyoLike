extends BaseRelic

signal add_relic_counter_buff(new_buff : int)

@export var counter_buff : int

func initialize():
	super()
	add_relic_counter_buff.connect(player.add_relic_counter_buff)
	add_relic_counter_buff.emit(2)
