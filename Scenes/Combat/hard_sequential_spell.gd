extends SpellNode
class_name  HardSequentialSpell

var current_component_stage : int = 0
var current_component_stage_flag : bool = false
var current_chain_match_found_flag : bool = false

func setup_processor(data : SpellData):
	recipe_type = SpellData.RECIPE_TYPE.HARD_SEQUENTIAL
	spell_data = data
	recipe_contents = spell_data.recipe_contents
	recipe_length = recipe_contents.size()

func process_block(grid_node_array : Array, new_chain_length : int):
	if current_component_stage == new_chain_length:
		current_component_stage_flag = true
	else:
		current_component_stage = new_chain_length
		current_component_stage_flag = false
		current_chain_match_found_flag = false
	
	var block_type : Puyo.PUYO_TYPE = grid_node_array[0].puyo.puyo_type
	var component_type : Puyo.PUYO_TYPE = recipe_contents[chain_stage_tracker]
	if block_type == component_type:
		spell_progressed.emit(chain_stage_tracker)
		chain_stage_tracker += 1
		current_chain_match_found_flag = true
	elif current_component_stage_flag == false and current_chain_match_found_flag == false:
		spell_reset()
	
	if chain_stage_tracker == recipe_length - 1:
		print("spell complete")
		spell_reset()

func spell_reset():
	spell_progress_reset.emit()
	chain_stage_tracker = 0
