extends Node2D

signal player_attack(PlayerAttack)
signal on_end_player_turn()
signal life_lost
signal block_popped(popped_puyos : Array, chain_value : int)

func end_player_turn() -> void:
	await $GridManager.down_tick()
	on_end_player_turn.emit()

func reset_game():
	$GridManager.show()
	$GridManager.end_game()
	$GridManager.start_game()

func pause_puyo():
	add_to_spawn_queue(PuyoQueueEvent.create(PuyoQueueEvent.EVENT_TYPE.END_GAME))
	$GridManager.delete_player()

func lose_life():
	print("life lost")
	$GridManager.end_game()
	$GridManager.hide()
	life_lost.emit()

func chain_stage_popped(chain_stage : Array, chain_value: int):
	for puyo_block : Array in chain_stage:
		block_popped.emit(puyo_block, chain_value)
		#print("chain type: ", puyo_block[0].get_type(), " with ", puyo_block.size(), " puyos, chain length ", chain_value)
		#send attack to the combat manager
		player_attack.emit(PlayerAttack.create(puyo_block, chain_value))

func add_to_spawn_queue(new_event: PuyoQueueEvent):
	$GridManager.add_to_spawn_queue(new_event)	

func process_damage_taken(damage_taken: int, attack_type: EnemyAttack.EnemyAttackType):
	add_to_spawn_queue(EnemyAttackHandler.process_attack(damage_taken, attack_type))
	#push_error("Dex todo: create a PuyoQueueEvent based on the data give, and pass it along to add_to_spawn_queue")
