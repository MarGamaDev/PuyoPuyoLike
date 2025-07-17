extends BaseRelic

signal deal_aoe_damage(damage : int)
signal deal_target_damage(damage : int)
signal gain_shield(shield : int)
signal gain_counter(counter : int)

@export var rainbow_mult_value_base : int = 4
var rainbow_mult_value : int = rainbow_mult_value_base

var chain_check_array : Array[Puyo.PUYO_TYPE] = []

func initialize() -> void:
	super()
	deal_aoe_damage.connect(combat_manager.damage_all_enemies)
	deal_target_damage.connect(combat_manager.damage_targeted_enemy)
	gain_shield.connect(combat_manager.gain_shield)
	gain_counter.connect(combat_manager.gain_counter)
	puyo_manager.on_chain_ending.connect(rainbow_attack_check)
	puyo_manager.block_popped.connect(process_block)

func process_block(popped_puyos : Array, chain_value : int):
	var popped_type : Puyo.PUYO_TYPE 
	if popped_puyos.is_empty():
		return
	popped_type = popped_puyos[0].get_type()
	if chain_check_array.has(popped_type) == false:
		deal_target_damage.emit(2000)
	combat_effects.create_relic_effect(self.global_position, combat_manager.selected_enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_RED, false)
	chain_check_array.append(popped_type)

func rainbow_attack_check(chain_length : int):
	print(chain_check_array)
	if chain_check_array.size() < 4:
		chain_check_array = []
	else:
		deal_aoe_damage.emit(rainbow_mult_value * chain_length)
		for i in combat_manager.enemies:
			combat_effects.create_relic_effect(self.global_position, i.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN, false)
		
		deal_target_damage.emit(rainbow_mult_value * chain_length)
		combat_effects.create_relic_effect(self.global_position, combat_manager.selected_enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_RED, false)
		
		gain_shield.emit(rainbow_mult_value * chain_length)
		combat_effects.create_relic_effect(self.global_position, combat_effects.shield_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_BLUE, false)
		
		gain_counter.emit(rainbow_mult_value * chain_length)
		combat_effects.create_relic_effect(self.global_position, combat_effects.counter_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_YELLOW, false)
		
		chain_check_array = []
	pass
