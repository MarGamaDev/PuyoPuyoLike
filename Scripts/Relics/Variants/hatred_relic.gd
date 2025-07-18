extends BaseRelic

##If a chain contains a block of green and a block of red, each subsequent
##block in the chain also triggers the effect of a block of green of the same
##size, but not effected by chain modifier

signal deal_aoe_damage(damage : int)

var chain_red_flag : bool = false
var chain_green_flag : bool = false


func initialize() -> void:
	super()
	deal_aoe_damage.connect(combat_manager.damage_all_enemies)
	puyo_manager.block_popped.connect(process_block)
	puyo_manager.on_chain_ending.connect(on_chain_end)

func process_block(popped_puyos : Array, chain_value : int):
	var popped_type : Puyo.PUYO_TYPE 
	if popped_puyos.is_empty():
		return
	popped_type = popped_puyos[0].get_type()
	match popped_type:
		Puyo.PUYO_TYPE.RED:
			chain_red_flag = true
		Puyo.PUYO_TYPE.GREEN:
			chain_green_flag = true
	if  chain_green_flag and chain_red_flag:
		print("hatred triggered")
		var value: int = puyo_values.get_base_value(Puyo.PUYO_TYPE.GREEN) * popped_puyos.size()
		deal_aoe_damage.emit(value)
		for enemy in combat_manager.enemies:
			combat_effects.create_relic_effect(self.global_position, enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN, true)

func on_chain_end(chain_length : int) -> void:
	chain_red_flag = false
	chain_green_flag = false
