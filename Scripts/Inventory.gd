extends Node

class_name Inventory

@export var temporary_test_inventory : Array[Reward] = []

func add_to_inventory(reward: Reward):
	temporary_test_inventory.append(reward.reward_name)
	print(temporary_test_inventory)
