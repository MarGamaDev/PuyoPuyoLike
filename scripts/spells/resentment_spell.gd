extends SequentialSpell

@export var spell_damage = 40

signal deal_spell_damage()

func connect_to_effect_signals():
	deal_spell_damage.connect(combat_manager.damage_targeted_enemy)
	print(deal_spell_damage.is_connected(combat_manager.damage_targeted_enemy))

func trigger_spell_effect():
	print("Resentment cast")
	deal_spell_damage.emit(spell_damage)
