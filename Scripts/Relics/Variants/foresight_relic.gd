extends BaseRelic

#if a chain contains 2 blocks of yellow bile, deal damage equal to your current
#counter at the end of chain (maybe this just triggers if a chain 2+ ends in yellow)

signal deal_targeted_damage(damage : int)

#false means this will look for 2 yellow blocks in a chain
#true means it will look to see if a block ends in a yellow chain
var use_last_puyo_block_flag : bool = false 

var yellow_blocks_popped_this_chain : int = 0
var last_type_popped : Puyo.PUYO_TYPE = Puyo.PUYO_TYPE.JUNK

func initialize() -> void:
	super()
	deal_targeted_damage.connect(combat_manager.damage_targeted_enemy)
	puyo_manager.on_chain_ending.connect(on_chain_end_check)
	puyo_manager.block_popped.connect(process_block)

func process_block(popped_puyos : Array, chain_value : int):
	var popped_type : Puyo.PUYO_TYPE 
	if popped_puyos.is_empty():
		return
	popped_type = popped_puyos[0].get_type()
	last_type_popped = popped_type
	if popped_type == Puyo.PUYO_TYPE.YELLOW:
		yellow_blocks_popped_this_chain += 1

func on_chain_end_check(chain_length : int) -> void:
	if use_last_puyo_block_flag:
		if last_type_popped == Puyo.PUYO_TYPE.YELLOW and chain_length > 1:
			deal_counter_damage()
	else:
		if yellow_blocks_popped_this_chain >= 2:
			deal_counter_damage()
	yellow_blocks_popped_this_chain = 0

func deal_counter_damage():
	deal_targeted_damage.emit(player.counter)
	combat_effects.create_relic_effect(combat_effects.counter_location_marker, combat_manager.selected_enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_YELLOW, true)
	print("counter launched!")
