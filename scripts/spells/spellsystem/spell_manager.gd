extends Node2D
class_name SpellManager

@export var test_spell : SpellData
@export var test_spell_2 : SpellData
@export var test_spell_3 :SpellData

@onready var equipped_spells : Array[SpellNode] = []

var chain_stage_tracker : int = 0

func add_spell(spell_data: SpellData):
	if equipped_spells.size() >= 3 or spell_data == null:
		print("too many spells!")
		push_error("todo, add selection window for equipping more spells")
	else:
		var spell_node : SpellNode
		spell_node = load(SpellFinder.find_spell(spell_data.spell_name)).instantiate()
		add_child(spell_node)
		
		spell_node.setup_spell_node(spell_data)
		equipped_spells.append(spell_node)
		var spell_container = $EquippedSpellsContainer.add_spell(spell_data)
		spell_node.on_spell_progressed.connect(spell_container.progress_spell_visual)
		spell_node.on_spell_progress_reset.connect(spell_container.reset_recipe_visual)
		spell_node.on_spell_complete.connect(spell_container.on_spell_complete)
		spell_node.connect_to_effect_signals()

func block_spell_check(puyo_array : Array, chain_length : int):
	if equipped_spells.size() < 1:
		return
	
	for i in equipped_spells:
		i.process_block(puyo_array, chain_length)

func on_player_turn_taken_spell_reset():
	$EquippedSpellsContainer.all_spell_reset()
	for i in equipped_spells:
		i.spell_reset()

func reset_spell_visuals():
	$EquippedSpellsContainer.all_spell_reset()
	
