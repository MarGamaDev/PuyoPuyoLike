extends SpellNode
class_name SequentialSpell

func check_block_against_recipe(grid_node_array : Array, new_chain_length : int):
	var block_type : Puyo.PUYO_TYPE = grid_node_array[0].puyo.puyo_type
	var component_type : Puyo.PUYO_TYPE = recipe_contents[spell_stage_tracker]
	if block_type == component_type:
		progress_spell(spell_stage_tracker)
	if spell_stage_tracker == recipe_length:
		complete_spell()
