extends FlexibleSpell

signal fireball_damage(number :int)
@onready var combat_manager

func setup_spell_node(data : SpellData):
	super(data)
	combat_manager = get_node("/root/Combat")
	combat_manager.connect("fireball_damage", combat_manager.damage_targeted_enemy)

func connect_to_effect_signals():
	pass

func check_block_against_recipe(grid_node_array : Array, new_chain_length : int):
	super (grid_node_array, new_chain_length)
	

func trigger_spell_effect():
	print("fireball!")
	fireball_damage.emit(10)
