extends Node

class_name Inventory

@export var temporary_test_inventory : Array[String] = []

func add_to_inventory(type: RewardChoice.REWARD_TYPE, name: String):
	temporary_test_inventory.append(name)
	print(temporary_test_inventory)
