extends BaseRelic

##if a chain contains blue and yellow, at the end of chain, deal damage to
##targeted enemy equal to your block * chain

signal deal_targeted_damage(damage : int)

var blue_popped_flag : bool = false
var yellow_popped_flag : bool = false

func initialize() -> void:
	super()
	deal_targeted_damage.connect(combat_manager.damage_targeted_enemy)
	puyo_manager.on_chain_ending.connect(on_chain_ending)
	puyo_manager.block_popped.connect(process_block)

func process_block(popped_puyos : Array, chain_value : int):
	var popped_type : Puyo.PUYO_TYPE 
	if popped_puyos.is_empty():
		return
	popped_type = popped_puyos[0].get_type()
	match popped_type:
		Puyo.PUYO_TYPE.BLUE:
			blue_popped_flag = true
		Puyo.PUYO_TYPE.YELLOW:
			yellow_popped_flag = true
	

func on_chain_ending(chain_length : int) -> void:
	if blue_popped_flag and yellow_popped_flag:
		deal_targeted_damage.emit(player.shield * chain_length)
		combat_effects.create_relic_effect(combat_effects.shield_location_marker, combat_manager.selected_enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_BLUE, true)
	blue_popped_flag = false
	yellow_popped_flag = false
	pass
