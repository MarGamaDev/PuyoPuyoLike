extends Node2D

class_name RewardManager

var reward_pool : Array[Reward]
@export var relic_data_folder_path = "res://Resources/RelicData/"
#@export var spell_data_folder_path = "res://Resources/SpellData/"
#var spell_data_file_list : PackedStringArray
var relic_data_file_list : PackedStringArray

var certain_puyo_type_relic_counter : int = 0
var certain_puyo_type_relic_flag : int = false

func _ready() -> void:
	#spell_data_file_list = ResourceLoader.list_directory(spell_data_folder_path)
	#for spell_file in spell_data_file_list:
	#	var spell = load(spell_data_folder_path + spell_file)
	#	var new_reward : Reward = Reward.create_spell_reward(spell)
	#	reward_pool.append(new_reward)
	relic_data_file_list = ResourceLoader.list_directory(relic_data_folder_path)
	for relic_file in relic_data_file_list:
		var relic = load(relic_data_folder_path + relic_file)
		var new_reward : Reward = Reward.create_relic_reward(relic)
		reward_pool.append(new_reward)

func get_pool() -> Array[Reward]:
	return reward_pool

func remove_from_pool(to_remove: Reward):
	if to_remove == null:
		#print("reward skipped")
		return
	if to_remove.reward_type == Reward.REWARD_TYPE.RELIC:
		if to_remove.relic_data.is_part_of_certain_cycle == true:
			certain_puyo_type_relic_counter += 1
			if certain_puyo_type_relic_counter >= 2:
				$RewardScreen.puyo_certain_relic_flag = true
		var index = reward_pool.find(to_remove)
		reward_pool[index].has_been_taken = true
