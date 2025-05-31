extends BaseRelic

#whenever you have a chain of 3 or higher, if red is inside the chain, gain shield
#equal to a third of the damage dealt
@export var chain_requirement :int = 3
@export var shield_gain_reducer : float = 0.3

signal gain_relic_shield(shield : int)

var red_flag = false
var damage_tracker : int = 0

func initialize() -> void:
	super()
	puyo_manager.player_attack.connect(check_block_type)
	puyo_manager.on_chain_ending.connect(trigger_red_defense)
	gain_relic_shield.connect(combat_manager.gain_shield)
	#print("red defense connected: %s" % puyo_manager.player_attack.is_connected(trigger_red_defense))


func check_block_type(attack: PlayerAttack) -> void:
	if attack.type == Puyo.PUYO_TYPE.RED:
		red_flag = true
	
	if attack.type == Puyo.PUYO_TYPE.RED or attack.type == Puyo.PUYO_TYPE.GREEN:
		var value: int = puyo_values.get_base_value(attack.type) * attack.size
		var mult: int = puyo_values.get_multiplier(attack.type) * attack.chain
		damage_tracker += value * mult
		#print("damage added")

func trigger_red_defense(max_chain : int):
	if red_flag and max_chain >= chain_requirement:
		sound_manager.relic_ding_play()
		print("red defense triggered, for shield %s" % (int(damage_tracker * shield_gain_reducer)))
		gain_relic_shield.emit(int(damage_tracker * shield_gain_reducer))
		combat_effects.create_relic_effect(self.global_position, combat_effects.shield_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_RED, false)
	red_flag = false
	damage_tracker = 0
