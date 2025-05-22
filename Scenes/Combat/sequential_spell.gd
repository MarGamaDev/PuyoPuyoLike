extends SpellNode
class_name SequentialSpell

func setup_processor(data : SpellData):
	recipe_type = SpellData.RECIPE_TYPE.SEQUENTIAL
	spell_data = data
	recipe_contents = spell_data.recipe_contents
	recipe_length = recipe_contents.size()

func process_block(grid_node_array : Array, new_chain_length : int):
	var block_type : Puyo.PUYO_TYPE = grid_node_array[0].puyo.puyo_type
	var component_type : Puyo.PUYO_TYPE = recipe_contents[chain_stage_tracker]
	if block_type == component_type:
		on_spell_progressed.emit(chain_stage_tracker)
		chain_stage_tracker += 1
	if chain_stage_tracker == recipe_length:
		on_spell_complete.emit()
		print("sequential complete")
		spell_reset()
