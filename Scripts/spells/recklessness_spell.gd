extends SequentialSpell

##recklessness deals flat damage to all enemies
signal deal_spell_damage(damage : int)

@export var spell_damage : int = 30

func connect_to_effect_signals():
	deal_spell_damage.connect(combat_manager.damage_all_enemies)

func trigger_spell_effect():
	var modifier = (EncounterTrackerForRelics.get_count() - 1) * 7
	deal_spell_damage.emit(spell_damage + modifier)
	for i in combat_manager.enemies:
		combat_effects.create_spell_effect(container_location_marker.global_position, i.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN)
	print("recklessness cast")
