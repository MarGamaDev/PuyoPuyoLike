extends Node2D

var last_chain_length : int = 0
var last_chain_contents : String = "Last chain contents: "
signal player_attack(PlayerAttack)
signal enemy_tick()

func lose_life():
	print("life lost")
	$GridManager.end_game()
	$GridManager.hide()
	test_reset_chain()
	
func chain_popped(puyos_to_pop : Array, chain_length: int):
	var chain_string = ""
	for puyo_group : Array in puyos_to_pop:
		print("chain type: ", puyo_group[0].get_type(), " with ", puyo_group.size(), " puyos, chain length ", chain_length)
		chain_string = chain_string + ("%s " % puyo_group[0].get_type()) + ("with %s" % puyo_group.size()) + " puyos "
		#send attack to the combat manager
		player_attack.emit(PlayerAttack.create_from_array(puyo_group, chain_length))
	if chain_length > 1:
		last_chain_contents = last_chain_contents + "\n" + chain_string			
	else:
		last_chain_contents = "Last chain contents: \n" + chain_string
	$UI/ChainRecipieLabel.text = last_chain_contents
	#updaing last chain length
	last_chain_length = chain_length
	$UI/ChainLengthLabel.text = "last chain length: %s" % last_chain_length

func test_reset_chain():
	last_chain_length  = 0
	last_chain_contents = "Last chain contents: "
	$UI/ChainLengthLabel.text = "last chain length: %s" % last_chain_length
	$UI/ChainRecipieLabel.text = last_chain_contents

func _on_test_button_pressed() -> void:
	$GridManager.show()
	$UI/Button.hide()

func _on_junk_test_pressed() -> void:
	$GridManager.add_to_spawn_queue(PuyoQueueEvent.create(PuyoQueueEvent.EVENT_TYPE.JUNK_SLAM,2))


func _on_test_reset_button_pressed() -> void:
	$GridManager.hide()
	$UI/Button.show()
