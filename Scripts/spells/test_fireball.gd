extends FlexibleSpell

signal fireball_damage(number :int)

func connect_to_effect_signals():
	fireball_damage.connect(combat_manager.damage_targeted_enemy)

func trigger_spell_effect():
	#print("fireball!")
	fireball_damage.emit(1)
