extends BaseRelic

signal deal_aoe_damage(damage : int)
signal deal_target_damage(damage : int)
signal gain_shield(shield : int)
signal gain_counter(counter : int)

func initialize():
	super()
	puyo_manager.block_popped.connect(wall_pop)
	print("wall_pop connected: %s" % puyo_manager.block_popped.is_connected(wall_pop))
	deal_aoe_damage.connect(combat_manager.damage_all_enemies)
	deal_target_damage.connect(combat_manager.damage_targeted_enemy)
	gain_shield.connect(combat_manager.gain_shield)
	gain_counter.connect(combat_manager.gain_counter)
	
#gets an array of gridnodes
func wall_pop(block : Array, chain_length : int):
	var wall_nodes : Array[GridNode] = []
	for grid_node : GridNode in block:
		if grid_node.neighbours.size() < 4:
			wall_nodes.append(grid_node)
	
	var blue_count = 0
	var yellow_count = 0
	var red_count = 0
	var green_count = 0
	
	for node_to_pop : GridNode in wall_nodes:
		match node_to_pop.puyo.puyo_type:
			Puyo.PUYO_TYPE.BLUE:
				blue_count += 1
			Puyo.PUYO_TYPE.YELLOW:
				yellow_count += 1
			Puyo.PUYO_TYPE.RED:
				red_count += 1
			Puyo.PUYO_TYPE.GREEN:
				green_count += 1
	
	deal_aoe_damage.emit(green_count * chain_length * puyo_values.green_base_value * puyo_values.green_chain_multiplier)
	deal_target_damage.emit(red_count * chain_length * puyo_values.red_base_value * puyo_values.red_chain_multiplier)
	gain_shield.emit(blue_count * chain_length * puyo_values.blue_chain_multiplier * puyo_values.blue_base_value)
	gain_counter.emit(yellow_count * chain_length * puyo_values. yellow_base_value * puyo_values.yellow_chain_multiplier)
	update_enemy_damage_visuals.emit()
	pass
