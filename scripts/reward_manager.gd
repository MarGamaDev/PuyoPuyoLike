extends Node2D

class_name RewardManager

@export var reward_pool : Array[Reward]

func get_pool() -> Array[Reward]:
	return reward_pool

func remove_from_pool(to_remove: Reward):
	var index = reward_pool.find(to_remove)
	reward_pool[index].has_been_taken = true
