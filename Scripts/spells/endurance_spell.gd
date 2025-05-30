extends FlexibleSpell

##gains sheild and delays the enemy's turn
@export var spell_shield_amount : int = 25
@export var enemy_delay_amount : int = 4

signal gain_spell_shield(shield : int)
signal delay_enemies(turns : int)

func connect_to_effect_signals():
	gain_spell_shield.connect(combat_manager.gain_shield)
	delay_enemies.connect(combat_manager.delay_enemies)

func trigger_spell_effect():
	gain_spell_shield.emit(spell_shield_amount)
	delay_enemies.emit(enemy_delay_amount)
	combat_effects.create_spell_effect(container_location_marker.global_position, combat_effects.shield_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_BLUE, false)
	for enemy : Enemy in combat_manager.enemies:
		combat_effects.create_spell_effect(container_location_marker.global_position, enemy.global_position , AttackEffectData.EFFECT_TYPE.PLAYER_BLUE, false)
	print("endurance cast")
