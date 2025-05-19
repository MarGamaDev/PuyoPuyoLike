extends Node2D

signal player_attack(PlayerAttack)
signal on_end_player_turn()

func end_player_turn() -> void:
	on_end_player_turn.emit()

func lose_life():
	print("life lost")
	$GridManager.end_game()
	$GridManager.hide()
	
func chain_popped(puyos_to_pop : Array, chain_length: int):
	for puyo_group : Array in puyos_to_pop:
		#print("chain type: ", puyo_group[0].get_type(), " with ", puyo_group.size(), " puyos, chain length ", chain_length)
		#send attack to the combat manager
		player_attack.emit(PlayerAttack.create_from_array(puyo_group, chain_length))

func add_to_spawn_queue(new_event: PuyoQueueEvent):
	$GridManager.add_to_spawn_queue(new_event)
