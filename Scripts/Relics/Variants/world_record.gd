extends BaseRelic

##each chain gets a bonus +x block after chain has been applied, where x is
##the highest chain reached this game

var highest_chain = 0
@export var bonus_per_chain_point : int = 1

signal send_bonus_attack(attack : PlayerAttack)

func initialize():
	super()
	puyo_manager.block_popped.connect(record_check)
	puyo_manager.on_chain_ending.connect(trigger_record_effect)
	send_bonus_attack.connect(combat_manager.process_player_attack)

func record_check(grid_node_array : Array, chain_value : int):
	if chain_value > highest_chain:
		highest_chain = chain_value
	pass

func trigger_record_effect(chain : int):
	if chain > 0:
		sound_manager.relic_ding_play()
		print("record procced with highest_chain : %s" % highest_chain)
		var type : Puyo.PUYO_TYPE
		match (randi_range(0,3)):
			0:
				type = Puyo.PUYO_TYPE.BLUE
			1:
				type = Puyo.PUYO_TYPE.RED
			2:
				type = Puyo.PUYO_TYPE.GREEN
			3:
				type = Puyo.PUYO_TYPE.YELLOW
		send_bonus_attack.emit(PlayerAttack.create_manually(bonus_per_chain_point * highest_chain, type, 1))
		match type:
			Puyo.PUYO_TYPE.RED:
				if combat_manager.selected_enemy != null:
					combat_effects.create_relic_effect(self.global_position, combat_manager.selected_enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_RED)
			Puyo.PUYO_TYPE.GREEN:
				for enemy : Enemy in combat_manager.enemies:
						combat_effects.create_relic_effect(self.global_position, enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN)
			Puyo.PUYO_TYPE.BLUE:
				combat_effects.create_relic_effect(self.global_position, combat_effects.shield_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_BLUE, false)
			Puyo.PUYO_TYPE.YELLOW:
				combat_effects.create_relic_effect(self.global_position, combat_effects.counter_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_YELLOW, false)
