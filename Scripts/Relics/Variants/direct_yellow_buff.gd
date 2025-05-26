extends BaseRelic

signal add_relic_counter_buff(new_buff : float)

@export var counter_buff : float = 1.5

func initialize():
	super()
	add_relic_counter_buff.connect(player.add_relic_counter_buff)
	add_relic_counter_buff.emit(counter_buff)
	
