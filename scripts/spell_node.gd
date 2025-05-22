extends Node2D
class_name SpellNode

signal on_spell_progress_reset
signal on_spell_progressed(chain_stage : int)
signal on_spell_complete

var spell_data : SpellData
var recipe_type : SpellData.RECIPE_TYPE
var chain_length : int = 0
var recipe_contents : Array[Puyo.PUYO_TYPE] = []
var recipe_length : int = 0
var chain_stage_tracker : int = 0

func setup_processor(data : SpellData):
	pass

func process_block(grid_node_array : Array, new_chain_length : int):
	pass

func spell_reset():
	on_spell_progress_reset.emit()
	chain_stage_tracker = 0
