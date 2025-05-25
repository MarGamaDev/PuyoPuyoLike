extends BaseRelic

signal deal_aoe_damage(damage : int)
signal deal_target_damage(damage : int)
signal gain_shield(shield : int)
signal gain_counter(counter : int)

func initialize() -> void:
	super()
	puyo_manager.block_popped.connect(block_boost)
	deal_aoe_damage.connect(combat_manager.damage_all_enemies)
	deal_target_damage.connect(combat_manager.damage_targeted_enemy)
	gain_shield.connect(combat_manager.gain_shield)
	gain_counter.connect(combat_manager.gain_counter)
	print("block_boost connected: %s" % deal_aoe_damage.is_connected(combat_manager.damage_all_enemies))

func block_boost(popped_puyos : Array, chain_value : int):
	print("block_boost activated")
	var puyo_value_data : PuyoValueData = combat_manager.puyo_values
	var puyo_block_size = popped_puyos.size()
	if puyo_block_size > 4:
		for i in range(0, puyo_block_size - 4):
			match (randi_range(0,3)):
				0:
					print("blue popped extra")
					gain_shield.emit(puyo_value_data.get_base_value(Puyo.PUYO_TYPE.BLUE) * puyo_value_data.get_multiplier(Puyo.PUYO_TYPE.BLUE) * chain_value)
				1:
					print("yellow popped extra")
					gain_counter.emit(puyo_value_data.get_base_value(Puyo.PUYO_TYPE.YELLOW) * puyo_value_data.get_multiplier(Puyo.PUYO_TYPE.YELLOW) * chain_value)
				2:
					print("red popped extra")
					deal_target_damage.emit(puyo_value_data.get_base_value(Puyo.PUYO_TYPE.RED) * puyo_value_data.get_multiplier(Puyo.PUYO_TYPE.RED) * chain_value)
				3:
					print("green popped extra")
					deal_aoe_damage.emit(puyo_value_data.get_base_value(Puyo.PUYO_TYPE.GREEN) * puyo_value_data.get_multiplier(Puyo.PUYO_TYPE.GREEN) * chain_value)
	update_enemy_damage_visuals.emit()
	##eventually add effects here instead
