extends Node2D
class_name SpellNode

signal spell_progress_reset
signal spell_progressed(chain_stage : int)

var spell_data : SpellData
var recipe_type : SpellData.RECIPE_TYPE
var chain_length : int = 0
var recipe_contents : Array[Puyo.PUYO_TYPE] = []
var recipe_length : int = 0
var chain_stage_tracker : int = 0
