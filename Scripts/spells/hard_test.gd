extends HardSequentialSpell

signal fireball_damage(number :int)

func connect_to_effect_signals():
	combat_manager = get_node("/root/Combat")
	fireball_damage.connect(combat_manager.damage_targeted_enemy)

func trigger_spell_effect():
	#print("hard sequential test")
	fireball_damage.emit(200)
