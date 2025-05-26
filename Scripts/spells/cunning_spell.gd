extends SequentialSpell

##triples the damage dealt the next time you counter

signal setup_counter_buff(multiplier : int)

var counter_buff : int = 2 #this is added to a 1 value, so having this equal to 1 is doubling

func connect_to_effect_signals():
	setup_counter_buff.connect(player.increase_counter_buff)

func trigger_spell_effect():
	setup_counter_buff.emit(counter_buff)
	print("cunning triggered")
