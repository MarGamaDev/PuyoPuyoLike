extends SequentialSpell

##recklessness deals flat damage to all enemies
signal deal_spell_damage(damage : int)

@export var spell_damage : int = 20

func connect_to_effect_signals():
	deal_spell_damage.connect(combat_manager.damage_all_enemies)

func trigger_spell_effect():
	deal_spell_damage.emit(spell_damage)
	print("recklessness cast")
