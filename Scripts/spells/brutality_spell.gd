extends SequentialSpell

##deals flat damage to targeted enemy on cast
signal deal_spell_damage(damage : int)

@export var spell_damage : int = 50

func connect_to_effect_signals():
	deal_spell_damage.connect(combat_manager.damage_targeted_enemy)


func trigger_spell_effect():
	var modifier = (EncounterTrackerForRelics.get_count() - 1)* 5
	deal_spell_damage.emit(spell_damage + modifier)
	combat_effects.create_spell_effect(container_location_marker.global_position, combat_manager.selected_enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_RED)
	#print("Brutality cast")
