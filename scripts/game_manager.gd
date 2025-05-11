extends Node2D

var last_chain_length : int = 0
var last_chain_contents : String = "Last chain contents: "

func lose_life():
	print("life lost")
	$GridManager.end_game()
	$GridManager.hide()
	test_reset_chain()
	
#chain_pop.emit(puyos_to_pop[0][0].get_type(), puyos_to_pop.size(), chain_length)
func chain_popped(puyos_to_pop : Array, chain_length: int):
	var chain_string = ""
	for puyo_group : Array in puyos_to_pop:
		print("chain type: ", puyo_group[0].get_type(), " with ", puyo_group.size(), " puyos, chain length ", chain_length)
		chain_string = chain_string + ("%s " % puyo_group[0].get_type()) + ("with %s" % puyo_group.size()) + " puyos "
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
	$UI/EndButton.show()


func _test_on_end_button_pressed() -> void:
	$GridManager.hide()
	$UI/EndButton.hide()
	$UI/Button.show()
	test_reset_chain()
