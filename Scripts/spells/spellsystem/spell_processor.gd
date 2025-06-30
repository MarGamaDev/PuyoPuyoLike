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

func setup_spell_processor(data : SpellData):
	#spell_node.on_spell_progressed.connect(progress_spell)
	#spell_node.on_spell_progress_reset.connect(reset_spell)
	#spell_node.on_spell_complete.connect(complete_spell)
	pass

func process_block(puyo_array : Array, chain_length : int):
	pass

func progress_spell(chain_stage: int):
	#on_spell_progressed.emit(chain_stage_tracker)
	#chain_stage_tracker += 1
	pass

func reset_spell():
	#on_spell_progress_reset.emit()
	#chain_stage_tracker = 0
	pass

func complete_spell():
	#on_spell_complete.emit()
	#reset_spell()
	##print("spell complete")
	pass
