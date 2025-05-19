extends Node2D

signal player_attack(PlayerAttack)
signal on_end_player_turn()
signal life_lost
signal block_popped(popped_puyos : Array, chain_length : int)

func end_player_turn() -> void:
	await $GridManager.down_tick()
	on_end_player_turn.emit()

func reset_game():
	$GridManager.show()
	$GridManager.end_game()
	$GridManager.start_game()

func lose_life():
	print("life lost")
	$GridManager.end_game()
	$GridManager.hide()
	life_lost.emit()
	
func chain_popped(puyos_to_pop : Array, chain_length: int):
	for puyo_group : Array in puyos_to_pop:
		block_popped.emit(puyo_group, chain_length)
		#print("chain type: ", puyo_group[0].get_type(), " with ", puyo_group.size(), " puyos, chain length ", chain_length)
		#send attack to the combat manager
		player_attack.emit(PlayerAttack.create_from_array(puyo_group, chain_length))

func add_to_spawn_queue(new_event: PuyoQueueEvent):
	$GridManager.add_to_spawn_queue(new_event)
