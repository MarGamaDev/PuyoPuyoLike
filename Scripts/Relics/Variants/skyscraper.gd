extends BaseRelic

signal skyscraper_attack(attack : PlayerAttack)

##gives blocks extra puyos, if they are above a certain threshold on the board
@export var height_threshold : int = 6
@export var extra_puyos_on_success : int = 2



func initialize():
	super()
	puyo_manager.block_popped.connect(skyscraper_trigger)
	skyscraper_attack.connect(combat_manager.process_player_attack)

#gets an array of gridnodes
func skyscraper_trigger(block : Array, chain_length):
	var highest_point = 12
	for grid_node: GridNode in block:
		if grid_node.grid_index.y < highest_point:
			highest_point = grid_node.grid_index.y
	if highest_point < height_threshold:
		var modifier = int((EncounterTrackerForRelics.get_count() - 1) / 3)
		sound_manager.relic_ding_play()
		print("skyscraper procced")
		skyscraper_attack.emit(PlayerAttack.create_manually(extra_puyos_on_success + modifier, block[0].puyo.puyo_type, chain_length))
		match block[0].puyo.puyo_type:
			Puyo.PUYO_TYPE.BLUE:
				combat_effects.create_relic_effect(self.global_position, combat_effects.shield_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_BLUE, false)
			Puyo.PUYO_TYPE.YELLOW:
				combat_effects.create_relic_effect(self.global_position, combat_effects.counter_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_YELLOW, false)
			Puyo.PUYO_TYPE.RED:
				combat_effects.create_relic_effect(self.global_position, combat_manager.selected_enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_RED)
			Puyo.PUYO_TYPE.GREEN:
				for enemy : Enemy in combat_manager.enemies:
					combat_effects.create_relic_effect(self.global_position, enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN)
	pass
