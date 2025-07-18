extends Node2D
class_name SpellNode

signal on_spell_progress_reset
signal on_spell_progressed(chain_stage : int)
signal on_spell_complete(spell_length : int, spell_name : String)

@export var spell_data : SpellData
var recipe_type : SpellData.RECIPE_TYPE
var chain_length : int = 0
var recipe_contents : Array[Puyo.PUYO_TYPE] = []
var recipe_length : int = 0
var spell_stage_tracker : int = 0
var chain_stage_tracker : int = 0

var container_location_marker : Control

@onready var combat_manager : CombatManager = get_node("/root/Combat")
@onready var puyo_manager : PuyoManager = get_node("/root/Combat/PuyoManager")
@onready var player : Player = get_node("/root/Combat/Player")
@onready var encounter_manager : EncounterManager = get_node("/root/Combat/EncounterManager")
@onready var combat_effects : CombatEffectsManager = get_node("/root/Combat/CombatEffectsManager")
@onready var sound_manager : SoundManager = get_node("/root/Combat/SoundManager")
signal update_enemy_damage_visuals

##go through the children to see what i can add super to
func connect_to_effect_signals():
	pass

func setup_spell_node(data : SpellData):
	spell_data = data
	recipe_type = spell_data.recipe_type
	recipe_contents = spell_data.recipe_contents
	recipe_length = recipe_contents.size()
	connect_to_effect_signals()
	

func process_block(grid_node_array : Array, new_chain_length : int):
	chain_length = new_chain_length
	if chain_length < chain_stage_tracker - 1:
		#print("test")
		chain_stage_tracker = 0
		spell_reset()
	
	if grid_node_array.is_empty():
		return
	else:
		check_block_against_recipe(grid_node_array, chain_length)

func check_block_against_recipe(grid_node_array: Array, chain_length : int):
	pass

func spell_reset():
	on_spell_progress_reset.emit()
	spell_stage_tracker = 0
	chain_stage_tracker = 0

func trigger_spell_effect():
	pass

func progress_spell(chain_stage: int):
	on_spell_progressed.emit(chain_stage)
	sound_manager.spell_build_up_play()
	chain_stage_tracker += 1

func complete_spell():
	##play sfx here
	on_spell_complete.emit(recipe_length, spell_data.spell_name)
	trigger_spell_effect()
	##remember to override without the reset for spells that care about how much
	##you chain after casting
	spell_reset()
	#print("spell complete")

func link_to_contianer(new_container_marker : Control):
	container_location_marker = new_container_marker
