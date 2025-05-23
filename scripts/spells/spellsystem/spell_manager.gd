extends Node2D
class_name SpellManager

@export var test_spell : SpellData
@export var test_spell_2 : SpellData
@export var test_spell_3 :SpellData

@onready var equipped_spells : Array[SpellNode] = []

var chain_stage_tracker : int = 0

func add_spell(spell_data: SpellData):
	if equipped_spells.size() >= 3:
		print("too many spells!")
		push_error("todo, add selection window for equipping more spells")
	else:
		var spell_node : SpellNode
		if spell_data.spell_name == "fireball":
			spell_node = load(SpellFinder.find_spell(spell_data.spell_name)).instantiate()
			add_child(spell_node)
		else:
			print("bad load")
			match  spell_data.recipe_type:
				SpellData.RECIPE_TYPE.HARD_SEQUENTIAL:
					spell_node = load("res://Scenes/spells/hard_sequential_spell.tscn").instantiate()
					add_child(spell_node)
				SpellData.RECIPE_TYPE.SEQUENTIAL:
					spell_node = load("res://Scenes/spells/sequential_spell.tscn").instantiate()
					add_child(spell_node)
				SpellData.RECIPE_TYPE.FLEXIBLE:
					spell_node = load("res://Scenes/spells/flexible_spell.tscn").instantiate()
					add_child(spell_node)
		
		spell_node.setup_spell_node(spell_data)
		equipped_spells.append(spell_node)
		$SpellHolder.add_child(spell_node)
		spell_node.on_spell_progressed.connect(progress_spell_visuals)
		spell_node.on_spell_progress_reset.connect(reset_spell_visuals)
		spell_node.on_spell_complete.connect(spell_complete_visuals)
		$EquippedSpellsContainer.add_spell(spell_data)

func block_spell_check(puyo_array : Array, chain_length : int):
	if equipped_spells.size() < 1:
		return
	
	for i in equipped_spells:
		i.process_block(puyo_array, chain_length)

func on_player_turn_taken_spell_reset():
	$EquippedSpellsContainer.on_player_turn_taken_spell_reset()
	for i in equipped_spells:
		i.spell_reset()

func progress_spell_visuals(spell_stage : int):
	#update the visuals
	pass

func reset_spell_visuals():
	#reset visuals
	pass

func spell_complete_visuals():
	#do completion visuals for methods
	pass
