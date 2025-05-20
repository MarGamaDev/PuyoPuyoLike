extends Control

class_name RewardChoice

signal on_reward_chosen(type : REWARD_TYPE, name : String)

enum REWARD_TYPE{SPELL, ITEM}
var reward_type : REWARD_TYPE
var reward_name : String
var reward_screen : Node

func create_reward(type: REWARD_TYPE, name : String):
	reward_name = name
	$RewardNameLabel.text = reward_name


func _on_button_pressed() -> void:
	on_reward_chosen.emit(reward_type, reward_name)
