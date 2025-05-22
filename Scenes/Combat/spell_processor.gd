extends Node2D
class_name SpellProcessor

signal on_spell_progress_reset
signal on_spell_progressed(chain_stage : int)
signal on_spell_complete

var spell_data : SpellData
var recipe_type : SpellData.RECIPE_TYPE = SpellData.RECIPE_TYPE.FLEXIBLE
var recipe_contents : Array[Puyo.PUYO_TYPE] = []
var recipe_length : int = 0
var spell_node : SpellNode

var chain_stage_tracker : int = 0

func setup_spell_processor(data : SpellData, type : SpellData.RECIPE_TYPE, contents : Array[Puyo.PUYO_TYPE]):
	spell_data = data
	recipe_type = type
	recipe_contents = contents
	recipe_length = recipe_contents.size()
	
	match  recipe_type:
		SpellData.RECIPE_TYPE.HARD_SEQUENTIAL:
			spell_node = load("res://Scenes/Combat/hard_sequential_spell.tscn").instantiate()
			add_child(spell_node)
		SpellData.RECIPE_TYPE.SEQUENTIAL:
			spell_node = load("res://Scenes/Combat/sequential_spell.tscn").instantiate()
			add_child(spell_node)
	
	spell_node.setup_processor(spell_data)
	spell_node.on_spell_progressed.connect(progress_spell)
	spell_node.on_spell_progress_reset.connect(reset_spell)
	spell_node.on_spell_complete.connect(complete_spell)

func process_block(puyo_array : Array, chain_length : int):
	if chain_length <= chain_stage_tracker:
		spell_node.spell_reset()
		reset_spell()
	
	if puyo_array.is_empty():
		print("empty block")
		return
	else:
		spell_node.process_block(puyo_array, chain_length)

func progress_spell(chain_stage: int):
	on_spell_progressed.emit(chain_stage_tracker)
	chain_stage_tracker += 1

func reset_spell():
	on_spell_progress_reset.emit()
	chain_stage_tracker = 0
	#print("spell reset")

func complete_spell():
	on_spell_complete.emit()
	reset_spell()
	print("spell complete")
