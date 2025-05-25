extends Resource

class_name Reward

enum REWARD_TYPE{SPELL, RELIC}
@export var reward_type : REWARD_TYPE
@export var spell_data : SpellData
@export var relic_data : RelicData
var has_been_taken : bool = false

static func create_spell_reward(spell : SpellData) -> Reward:
	var instance = Reward.new()
	instance.reward_type = REWARD_TYPE.SPELL
	instance.spell_data = spell
	instance.has_been_taken = false
	return instance

static func create_relic_reward(relic :RelicData) -> Reward:
	var instance = Reward.new()
	instance.reward_type = REWARD_TYPE.RELIC
	instance.relic_data = relic
	instance.has_been_taken = false
	return instance
