extends FlexibleSpell

signal fireball_damage(number :int)
@onready var combat_manager = get_node("/root/Combat")

func connect_to_effect_signals():
	combat_manager = get_node("/root/Combat")
	fireball_damage.connect(combat_manager.damage_targeted_enemy)

func check_block_against_recipe(grid_node_array : Array, new_chain_length : int):
	super (grid_node_array, new_chain_length)
	

func trigger_spell_effect():
	print("fireball!")
	fireball_damage.emit(200)
