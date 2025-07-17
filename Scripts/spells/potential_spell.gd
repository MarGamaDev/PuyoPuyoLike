extends FlexibleSpell

##after doing a chained rainbow in a specific order, at the end of the chain,
##trigger the effect of each puyo type (rainbow mult value * chain length) times

@export var rainbow_mult_value_base : int = 4

var rainbow_mult_value : int = rainbow_mult_value_base
signal deal_aoe_damage(damage : int)
signal deal_target_damage(damage : int)
signal gain_shield(shield : int)
signal gain_counter(counter : int)

var spell_trigger_flag = false

func connect_to_effect_signals():
	deal_aoe_damage.connect(combat_manager.damage_all_enemies)
	deal_target_damage.connect(combat_manager.damage_targeted_enemy)
	gain_shield.connect(combat_manager.gain_shield)
	gain_counter.connect(combat_manager.gain_counter)
	puyo_manager.on_chain_ending.connect(rainbow_attack)

func trigger_spell_effect():
	#print("ambition trigger")
	spell_trigger_flag = true
	if !(puyo_manager.on_chain_ending.is_connected(rainbow_attack)):
		puyo_manager.on_chain_ending.connect(rainbow_attack)

func rainbow_attack(chain_length : int):
	rainbow_mult_value = rainbow_mult_value_base + EncounterTrackerForRelics.get_count()
	if spell_trigger_flag == false:
		return
	spell_trigger_flag = false
	#print("ambition rainbow attack!")
	puyo_manager.on_chain_ending.disconnect(rainbow_attack)
	
	deal_aoe_damage.emit(rainbow_mult_value * chain_length)
	for i in combat_manager.enemies:
		combat_effects.create_spell_effect(container_location_marker.global_position, i.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN, true)
	
	deal_target_damage.emit(rainbow_mult_value * chain_length)
	combat_effects.create_spell_effect(container_location_marker.global_position, combat_manager.selected_enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_RED, true)
	
	gain_shield.emit(rainbow_mult_value * chain_length)
	combat_effects.create_spell_effect(container_location_marker.global_position, combat_effects.shield_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_BLUE, false)
	
	gain_counter.emit(rainbow_mult_value * chain_length)
	combat_effects.create_spell_effect(container_location_marker.global_position, combat_effects.counter_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_YELLOW, false)
