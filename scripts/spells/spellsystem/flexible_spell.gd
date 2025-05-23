extends SpellNode
class_name FlexibleSpell

var unchecked_components : Array[Puyo.PUYO_TYPE] = []

func setup_spell_node(data : SpellData):
	recipe_type = SpellData.RECIPE_TYPE.SEQUENTIAL
	spell_data = data
	recipe_contents = spell_data.recipe_contents
	recipe_length = recipe_contents.size()
	setup_flexible_array(recipe_contents)
	connect_to_effect_signals()

func check_block_against_recipe(grid_node_array : Array, new_chain_length : int):
	var block_type : Puyo.PUYO_TYPE = grid_node_array[0].puyo.puyo_type
	var remove_flag
	for i in range (0, unchecked_components.size()):
		if unchecked_components[i] == block_type:
			spell_stage_tracker = i
			progress_spell(i)
			unchecked_components.remove_at(i)
			break
	
	if spell_stage_tracker == recipe_length:
		complete_spell()

func spell_reset():
	super()
	setup_flexible_array(recipe_contents)

func trigger_spell_effect():
	pass

func setup_flexible_array(new_contents):
	unchecked_components = []
	for i in range(0, recipe_length):
		unchecked_components.append(Puyo.PUYO_TYPE.UNDEFINED)
	for i in range(0, new_contents.size()):
		unchecked_components[i] = new_contents[i]
