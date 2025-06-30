extends SequentialSpell

signal gain_spell_shield(shield : int)

@export var spell_shield : int = 20

func connect_to_effect_signals():
	gain_spell_shield.connect(combat_manager.gain_shield)

func trigger_spell_effect():
	var modifier = (EncounterTrackerForRelics.get_count() - 1)* 5
	gain_spell_shield.emit(spell_shield + modifier)
	combat_effects.create_spell_effect(container_location_marker.global_position, combat_effects.shield_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_BLUE, false)
	#print("caution cast")
