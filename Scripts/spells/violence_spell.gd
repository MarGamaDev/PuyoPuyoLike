extends HardSequentialSpell

@export var spell_base_damage : int = 10

signal deal_spell_damage(damage : int)

func connect_to_effect_signals():
	deal_spell_damage.connect(combat_manager.damage_all_enemies)

func trigger_spell_effect():
	var enemy_count = encounter_manager.current_encounter.enemy_count
	deal_spell_damage.emit(spell_base_damage * enemy_count)
	for i in combat_manager.enemies:
		combat_effects.create_spell_effect(container_location_marker.global_position, i.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN)
	print("Violence cast for: %s" % (enemy_count * spell_base_damage))
