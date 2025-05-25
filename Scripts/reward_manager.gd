extends Node2D

class_name RewardManager

var reward_pool : Array[Reward]

@export var spell_data_folder_path = "res://Resources/SpellData/"
var spell_data_file_list : PackedStringArray

func _ready() -> void:
	spell_data_file_list = DirAccess.get_files_at(spell_data_folder_path)
	for spell_file in spell_data_file_list:
		var spell = load(spell_data_folder_path + spell_file)
		var new_reward : Reward = Reward.create_spell_reward(spell)
		reward_pool.append(new_reward)

func get_pool() -> Array[Reward]:
	return reward_pool

func remove_from_pool(to_remove: Reward):
	if to_remove == null:
		print("reward skipped")
		return
	var index = reward_pool.find(to_remove)
	reward_pool[index].has_been_taken = true
