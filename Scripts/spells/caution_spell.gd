extends SequentialSpell

signal gain_spell_shield(shield : int)

@export var spell_shield : int = 20

func connect_to_effect_signals():
	gain_spell_shield.connect(combat_manager.gain_shield)

func trigger_spell_effect():
	gain_spell_shield.emit(spell_shield)
	print("caution cast")
