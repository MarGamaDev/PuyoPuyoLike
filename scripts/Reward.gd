extends Resource

class_name Reward

enum REWARD_TYPE{SPELL, ITEM}
@export var reward_type : REWARD_TYPE
@export var reward_name : String
@export var reward_description : String
@export var item_texture : Texture2D
@export var spell_data : SpellData

func create_reward(type : REWARD_TYPE, name : String, description : String):
	reward_type = type
	reward_name = name
	reward_description = description
	item_texture = load("res://Placeholder Art/box.png")

func item_create(texture : Texture2D):
	item_texture = texture

func spell_create(data : SpellData):
	spell_data = data
