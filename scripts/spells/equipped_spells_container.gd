extends CanvasLayer

@onready var equipped_spells : Array[SpellContainer] = []

@onready var spell_container_scene : PackedScene = preload("res://Scenes/spells/spell_container.tscn")

@export var test_spell : SpellData
@export var test_spell_2 : SpellData
@export var test_spell_3 :SpellData

@onready var test_spells = [test_spell, test_spell_2, test_spell_3]
func test_spell_get():
	return test_spells

func add_spell(spell_data: SpellData):
	if equipped_spells.size() >= 3:
		print("too many spells!")
		push_error("todo, add selection window for equipping more spells")
	else:
		var new_container : SpellContainer = spell_container_scene.instantiate()
		new_container.create_spell_container(spell_data)
		equipped_spells.append(new_container)
		$EquippedSpellsBox.add_child(new_container)
		

func block_spell_check(puyo_array : Array, chain_length : int):
	if equipped_spells.size() < 1:
		return
	
	for i in equipped_spells:
		i.process_block(puyo_array, chain_length)

func on_player_turn_taken_spell_reset():
	for i in equipped_spells:
		i.reset_recipe_visual()
