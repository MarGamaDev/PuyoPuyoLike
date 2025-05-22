extends FlexibleSpell

signal fireball_damage(number :int)

func connect_to_effect_signals():
	pass

func trigger_spell_effect():
	print("fireball!")
