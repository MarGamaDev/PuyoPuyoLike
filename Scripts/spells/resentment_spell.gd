extends FlexibleSpell

#deals a damage blast to every enemy
@export var spell_aoe_damage = 30
@export var spell_target_damage = 15

signal deal_spell_damage(damage : int)
signal deal_target_damage(damage: int)

func connect_to_effect_signals():
	deal_spell_damage.connect(combat_manager.damage_all_enemies)
	deal_target_damage.connect(combat_manager.damage_targeted_enemy)

func trigger_spell_effect():
	print("Resentment cast")
	var modifier = (EncounterTrackerForRelics.get_count() - 1)* 5
	deal_spell_damage.emit(spell_aoe_damage + modifier)
	for i in combat_manager.enemies:
		combat_effects.create_spell_effect(container_location_marker.global_position, i.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN)
	deal_target_damage.emit(spell_target_damage + modifier)
	combat_effects.create_spell_effect(container_location_marker.global_position, combat_manager.selected_enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_RED)
