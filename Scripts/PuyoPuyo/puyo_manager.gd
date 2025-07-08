extends Node2D
class_name PuyoManager

signal player_attack(PlayerAttack)
signal on_end_player_turn()
signal life_lost
#emits an array of gridnodes
signal block_popped(popped_puyos : Array, chain_value : int)
signal on_player_created
signal on_chain_ending(max_chain : int)
signal on_junk_popped(amount: int)
signal on_junk_created(amount: int)

@export var game_manager : PuyoGameManager

func _ready():
	#add_certain_puyo_relic_type(Puyo.PUYO_TYPE.GREEN)
	pass

func end_player_turn() -> void:
	await game_manager.down_tick()
	on_end_player_turn.emit()

func reset_game():
	game_manager.show()
	game_manager.end_game()
	game_manager.start_game()

func pause_puyo():
	add_to_spawn_queue(PuyoQueueEvent.create(PuyoQueueEvent.EVENT_TYPE.END_GAME))
	game_manager.delete_player()

func lose_life():
	#print("life lost")
	game_manager.end_game()
	game_manager.hide()
	life_lost.emit()

#chain_stage is an array of arrays of gridnodes
func chain_stage_popped(chain_stage : Array, chain_value: int):
	if chain_stage.size() > 0:
		game_manager.sound_manager.play_puyo_pop()
	for puyo_block : Array in chain_stage:
		#emits an array og gridnodes
		block_popped.emit(puyo_block, chain_value)
		##print("chain type: ", puyo_block[0].get_type(), " with ", puyo_block.size(), " puyos, chain length ", chain_value)
		#send attack to the combat manager
		player_attack.emit(PlayerAttack.create(puyo_block, chain_value))

func add_to_spawn_queue(new_event: PuyoQueueEvent):
	game_manager.add_to_spawn_queue(new_event)	

func process_damage_taken(damage_taken: int, attack: EnemyAttack):
	add_to_spawn_queue(EnemyAttackHandler.process_attack(damage_taken, attack))
	#push_error("Dex todo: create a PuyoQueueEvent based on the data give, and pass it along to add_to_spawn_queue")


func _on_player_created() -> void:
	on_player_created.emit()

func _on_grid_manager_chain_ended(max_chain: int) -> void:
	on_chain_ending.emit(max_chain)

func destroy_leftover_puyos():
	#for to_delete in get_tree().get_nodes_in_group("Puyos"):
		#to_delete.queue_free()
	pass


func _on_grid_manager_junk_popped(amount: int) -> void:
	on_junk_popped.emit(amount)
	pass # Replace with function body.


func _on_grid_manager_junk_created(amount: int) -> void:
	on_junk_created.emit(amount)
	pass # Replace with function body.

func add_certain_puyo_relic_type(type : Puyo.PUYO_TYPE):
	game_manager.add_certain_puyo(type)
	

func get_free_spaces_left()->int:
	return game_manager.get_free_spaces_left()

func get_global_grid_position(pos : Vector2i) -> Vector2:
	return game_manager.get_global_position_from_grid(pos)
