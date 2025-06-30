extends SequentialSpell

#triggers all puyos along the walls and floor and ceiling
signal deal_aoe_damage(damage : int)
signal deal_target_damage(damage : int)
signal gain_shield(shield : int)
signal gain_counter(counter : int)

@onready var grid_manager : GridManager = puyo_manager.grid_manager

var spell_trigger_flag = false

func connect_to_effect_signals():
	deal_aoe_damage.connect(combat_manager.damage_all_enemies)
	deal_target_damage.connect(combat_manager.damage_targeted_enemy)
	gain_shield.connect(combat_manager.gain_shield)
	gain_counter.connect(combat_manager.gain_counter)
	puyo_manager.on_chain_ending.connect(wall_pop)

func trigger_spell_effect():
	spell_trigger_flag = true
	if !(puyo_manager.on_chain_ending.is_connected(wall_pop)):
		puyo_manager.on_chain_ending.connect(wall_pop)
	#print("adamance test")

func wall_pop(chain_length : int):
	if spell_trigger_flag == false:
		return
	spell_trigger_flag = false
	puyo_manager.on_chain_ending.disconnect(wall_pop)
	#print("wall pop test")
	var blue_count = 0
	var yellow_count = 0
	var red_count = 0
	var green_count = 0
	for i in range(0, grid_manager.grid_width):
		for j in range(0, grid_manager.grid_height):
			if grid_manager.grid[i][j].puyo != null and grid_manager.grid[i][j].is_holding_puyo:
				if grid_manager.grid[i][j].puyo.puyo_type != Puyo.PUYO_TYPE.JUNK:
					grid_manager.grid[i][j].puyo.trigger_pop_effect()
				if grid_manager.grid[i][j].neighbours.size() < 4 :
					match grid_manager.grid[i][j].puyo.puyo_type:
						Puyo.PUYO_TYPE.BLUE:
							blue_count += 1
						Puyo.PUYO_TYPE.YELLOW:
							yellow_count += 1
						Puyo.PUYO_TYPE.RED:
							red_count += 1
						Puyo.PUYO_TYPE.GREEN:
							green_count += 1
	if green_count > 0:
		deal_aoe_damage.emit(green_count * chain_length)
		for i in combat_manager.enemies:
			combat_effects.create_spell_effect(container_location_marker.global_position, i.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN)
	if red_count > 0:
		deal_target_damage.emit(red_count * chain_length)
		combat_effects.create_spell_effect(container_location_marker.global_position, combat_manager.selected_enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_RED)
	if blue_count > 0:
		gain_shield.emit(blue_count * chain_length)
		combat_effects.create_spell_effect(container_location_marker.global_position, combat_effects.shield_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_BLUE, false)
	if yellow_count > 0:
		gain_counter.emit(yellow_count * chain_length)
		combat_effects.create_spell_effect(container_location_marker.global_position, combat_effects.counter_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_YELLOW, false)
