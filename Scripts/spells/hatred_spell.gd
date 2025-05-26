extends FlexibleSpell

##afer casting, the rest of the chain is treated as if there were also green
##blocks being popped in addition to the current block

signal deal_phlegm_spell_damage(damage : int)

@export var puyo_values: PuyoValueData

var hatred_flag : bool = false

func connect_to_effect_signals():
	deal_phlegm_spell_damage.connect(combat_manager.damage_all_enemies)

func check_block_against_recipe(grid_node_array : Array, new_chain_length : int):
	super(grid_node_array, new_chain_length)
	if hatred_flag:
		launch_hatred_attack(grid_node_array, new_chain_length)

func spell_reset():
	super()
	hatred_flag = false

func trigger_spell_effect():
	print("hatred cast")
	hatred_flag = true

func launch_hatred_attack(grid_node_array : Array, new_chain_length : int):
	#print(grid_node_array.size())
	var value: int = puyo_values.get_base_value(Puyo.PUYO_TYPE.GREEN) * grid_node_array.size()
	var mult: int = puyo_values.get_multiplier(Puyo.PUYO_TYPE.GREEN) * new_chain_length
	deal_phlegm_spell_damage.emit(value * mult)
	for i in combat_manager.enemies:
		combat_effects.create_spell_effect(container_location_marker.global_position, i.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN)

func complete_spell():
	on_spell_complete.emit(recipe_length)
	trigger_spell_effect()
	print("spell complete")
