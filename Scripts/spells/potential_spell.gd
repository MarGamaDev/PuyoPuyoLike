extends SequentialSpell

##after doing a chained rainbow in a specific order, at the end of the chain,
##trigger the effect of each puyo type (rainbow mult value * chain length) times

@export var rainbow_mult_value : int = 5

signal deal_aoe_damage(damage : int)
signal deal_target_damage(damage : int)
signal gain_shield(shield : int)
signal gain_counter(counter : int)

var spell_trigger_flag = false

func connect_to_effect_signals():
	deal_aoe_damage.connect(combat_manager.damage_all_enemies)
	deal_target_damage.connect(combat_manager.damage_targeted_enemy)
	gain_shield.connect(combat_manager.gain_shield)
	gain_counter.connect(combat_manager.gain_counter)
	puyo_manager.on_chain_ending.connect(rainbow_attack)

func trigger_spell_effect():
	spell_trigger_flag = true
	if !(puyo_manager.on_chain_ending.is_connected(rainbow_attack)):
		puyo_manager.on_chain_ending.connect(rainbow_attack)

func rainbow_attack(chain_length : int):
	if spell_trigger_flag == false:
		return
	spell_trigger_flag = false
	puyo_manager.on_chain_ending.disconnect(rainbow_attack)
	deal_aoe_damage.emit(rainbow_mult_value * chain_length)
	deal_target_damage.emit(rainbow_mult_value * chain_length)
	gain_shield.emit(rainbow_mult_value * chain_length)
	gain_counter.emit(rainbow_mult_value * chain_length)
