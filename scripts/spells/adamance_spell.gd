extends SequentialSpell

#triggers all puyos along the walls and floor and ceiling
signal simulate_player_attack(attack : PlayerAttack)

@onready var grid_manager : GridManager = puyo_manager.grid_manager
var pop_flag = false
func connect_to_effect_signals():
	simulate_player_attack.connect(combat_manager.process_player_attack)
	puyo_manager.on_chain_ending.connect(wall_pop)
	pass

func trigger_spell_effect():
	pop_flag = true
	print(puyo_manager.on_chain_ending.is_connected(wall_pop))
	print("adamance test")

func wall_pop(chain_length : int):
	if pop_flag == false:
		return
	pop_flag = false
	puyo_manager.on_chain_ending.disconnect(wall_pop)
	print("wall pop test")
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
	print(blue_count + yellow_count + red_count + green_count)
	push_error("FIX THIS TO ATTACK")
