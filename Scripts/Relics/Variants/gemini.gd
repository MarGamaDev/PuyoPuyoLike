extends BaseRelic

##if you pop a block that is the same color as one before in a chain, gain + 2 puyos to
##the current pop per each other one

signal symmetry_strike(attack : PlayerAttack)

@export var puyo_boost_per_match : int = 2

var types_in_chain : Array[Puyo.PUYO_TYPE] = []

func initialize():
	super()
	puyo_manager.on_chain_ending.connect(reset_relic)
	puyo_manager.block_popped.connect(gemini_trigger)
	symmetry_strike.connect(combat_manager.process_player_attack)

func reset_relic(max_chain_unused : int):
	#print("gemini reset")
	#print(types_in_chain)
	types_in_chain = []
	pass

#gets given an array of grid nodes
func gemini_trigger(block : Array, chain_length : int):
	var block_type : Puyo.PUYO_TYPE = block[0].puyo.puyo_type
	var bonus_counter = 0
	for i in range(0, types_in_chain.size()):
		if types_in_chain[i] == block_type:
			bonus_counter += 1
	types_in_chain.append(block_type)
	if bonus_counter > 0:
		var modifier = int((EncounterTrackerForRelics.get_count() - 1) / 3)
		bonus_counter += modifier
		#print("gemini procced")
		sound_manager.relic_ding_play()
		symmetry_strike.emit(PlayerAttack.create_manually(bonus_counter * puyo_boost_per_match, block_type, chain_length))
		match block_type:
			Puyo.PUYO_TYPE.RED:
				combat_effects.create_relic_effect(self.global_position, combat_manager.selected_enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_RED)
			Puyo.PUYO_TYPE.GREEN:
				for enemy : Enemy in combat_manager.enemies:
						combat_effects.create_relic_effect(self.global_position, enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN)
			Puyo.PUYO_TYPE.BLUE:
				combat_effects.create_relic_effect(self.global_position, combat_effects.shield_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_BLUE, false)
			Puyo.PUYO_TYPE.YELLOW:
				combat_effects.create_relic_effect(self.global_position, combat_effects.counter_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_YELLOW, false)
	
	pass
