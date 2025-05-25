extends Resource

class_name Reward

enum REWARD_TYPE{SPELL, ITEM}
@export var reward_type : REWARD_TYPE
@export var spell_data : SpellData
var has_been_taken : bool = false

static func create_spell_reward(spell : SpellData) -> Reward:
	var instance = Reward.new()
	instance.reward_type = REWARD_TYPE.SPELL
	instance.spell_data = spell
	instance.has_been_taken = false
	return instance
	
