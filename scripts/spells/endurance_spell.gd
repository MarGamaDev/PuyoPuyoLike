extends HardSequentialSpell

@export var spell_shield_amount : int = 10
@export var enemy_delay_amount : int = 3

signal gain_spell_shield(shield : int)
signal delay_enemies(turns : int)

func connect_to_effect_signals():
	gain_spell_shield.connect(combat_manager.gain_shield)
	delay_enemies.connect(combat_manager.delay_enemies)

func trigger_spell_effect():
	gain_spell_shield.emit(spell_shield_amount)
	delay_enemies.emit(enemy_delay_amount)
	print("endurance cast")
