extends BaseRelic

##if a chain contains 2 blocks of blue (or maybe just ends in blue), gain extra
##(not chain scaling) shield, and delay all enemy attacks by 3 + scaling turns

signal gain_shield(shield : int)
signal delay_enemies(turns : int)

var blue_pop_count : int = 0
var shield_gain_base : int = 15
var enemy_delay_base : int = 2

func initialize() -> void:
	super()
	puyo_manager.on_chain_ending.connect(on_chain_end)
	puyo_manager.block_popped.connect(process_block)
	gain_shield.connect(combat_manager.gain_shield)
	delay_enemies.connect(combat_manager.delay_enemies)

func process_block(popped_puyos : Array, chain_value : int):
	var popped_type : Puyo.PUYO_TYPE 
	if popped_puyos.is_empty():
		return
	popped_type = popped_puyos[0].get_type()
	if popped_type == Puyo.PUYO_TYPE.BLUE:
		blue_pop_count += 1

func on_chain_end(chain_length : int) -> void:
	if blue_pop_count >= 2:
		var modifier = (EncounterTrackerForRelics.get_count() - 1)* 5
		gain_shield.emit(shield_gain_base + modifier)
		delay_enemies.emit(enemy_delay_base + EncounterTrackerForRelics.get_count())
		combat_effects.create_relic_effect(self.global_position, combat_effects.shield_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_BLUE, false)
		for enemy : Enemy in combat_manager.enemies:
			combat_effects.create_relic_effect(combat_effects.shield_location_marker, enemy.global_position , AttackEffectData.EFFECT_TYPE.PLAYER_BLUE, false)
	blue_pop_count = 0
	pass
