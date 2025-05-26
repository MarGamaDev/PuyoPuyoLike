extends BaseRelic

signal skyscraper_attack(attack : PlayerAttack)

##gives blocks extra puyos, if they are above a certain threshold on the board
@export var height_threshold : int = 8
@export var extra_puyos_on_success : int = 3

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
		print("skyscraper procced")
		skyscraper_attack.emit(PlayerAttack.create_manually(extra_puyos_on_success, block[0].puyo.puyo_type, chain_length))
		update_enemy_damage_visuals.emit()
	pass
