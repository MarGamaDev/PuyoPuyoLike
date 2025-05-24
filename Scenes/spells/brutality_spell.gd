extends SequentialSpell

##deals flat damage to targeted enemy on cast
signal deal_spell_damage(damage : int)

@export var spell_damage : int = 50

func connect_to_effect_signals():
	deal_spell_damage.connect(combat_manager.damage_targeted_enemy)

func trigger_spell_effect():
	deal_spell_damage.emit(spell_damage)
	print("Brutality cast")
