extends SpellNode
class_name FlexibleSpell

var unchecked_components : Array[Puyo.PUYO_TYPE] = []

func setup_processor(data : SpellData):
	recipe_type = SpellData.RECIPE_TYPE.SEQUENTIAL
	spell_data = data
	recipe_contents = spell_data.recipe_contents
	recipe_length = recipe_contents.size()
	unchecked_components = recipe_contents

func process_block(grid_node_array : Array, new_chain_length : int):
	var block_type : Puyo.PUYO_TYPE = grid_node_array[0].puyo.puyo_type

	for i in range (0, unchecked_components.size()):
		if unchecked_components[i] == block_type:
			on_spell_progressed.emit(i)
			spell_stage_tracker += 1
			unchecked_components[i] == Puyo.PUYO_TYPE.UNDEFINED
			break
	
	if spell_stage_tracker == recipe_length:
		on_spell_complete.emit()
		print("flexible complete")
		spell_reset()

func spell_reset():
	on_spell_progress_reset.emit()
	spell_stage_tracker = 0
	unchecked_components = recipe_contents
