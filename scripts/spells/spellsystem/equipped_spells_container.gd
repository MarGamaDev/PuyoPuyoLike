extends CanvasLayer

@onready var equipped_spell_containers : Array[SpellContainer] = []

@onready var spell_container_scene : PackedScene = preload("res://Scenes/spells/spellSystem/spell_container.tscn")

func add_spell(spell_data: SpellData):
	var new_container : SpellContainer = spell_container_scene.instantiate()
	new_container.create_spell_container(spell_data)
	equipped_spell_containers.append(new_container)
	$EquippedSpellsBox.add_child(new_container)
	
##might be able to just remove this
func block_spell_check(puyo_array : Array, chain_length : int):
	#for i in equipped_spell_containers:
		#i.process_block(puyo_array, chain_length)
	pass

func on_player_turn_taken_spell_reset():
	for i in equipped_spell_containers:
		i.reset_recipe_visual()
