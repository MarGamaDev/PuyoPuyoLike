extends Resource

class_name Reward

enum REWARD_TYPE{SPELL, ITEM}
@export var reward_type : REWARD_TYPE
@export var spell_data : SpellData
var has_been_taken : bool = false
