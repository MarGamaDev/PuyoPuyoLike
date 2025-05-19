extends CanvasLayer

@export var puyo_manager : Node2D
@onready var grid_manager : Node2D = puyo_manager.find_child("GridManager")

var last_chain_length : int = 0
var last_chain_contents : String = "Last chain contents: "

func _ready():
	grid_manager.connect("chain_pop", chain_popped)

func chain_popped(puyos_to_pop : Array, chain_length: int):
	var chain_string = ""
	for puyo_group : Array in puyos_to_pop:
		chain_string = chain_string + ("%s " % puyo_group[0].get_type()) + ("with %s" % puyo_group.size()) + " puyos "
	if chain_length > 1:
		last_chain_contents = last_chain_contents + "\n" + chain_string			
	else:
		last_chain_contents = "Last chain contents: \n" + chain_string
	$ChainRecipieLabel.text = last_chain_contents
	#updaing last chain length
	last_chain_length = chain_length
	$ChainLengthLabel.text = "last chain length: %s" % last_chain_length

func test_reset_chain():
	last_chain_length  = 0
	last_chain_contents = "Last chain contents: "
	$ChainLengthLabel.text = "last chain length: %s" % last_chain_length
	$ChainRecipieLabel.text = last_chain_contents

func _on_button_pressed() -> void:
	$Button.hide()
	grid_manager.show()
	grid_manager.start_game()

func _on_test_reset_button_pressed() -> void:
	$Button.show()
	grid_manager.hide()
	grid_manager.end_game()

func _on_junk_test_pressed() -> void:
	grid_manager.add_to_spawn_queue(PuyoQueueEvent.create(PuyoQueueEvent.EVENT_TYPE.JUNK_SLAM,2))
