extends Control

class_name Reward

signal on_reward_chosen(name : String)

var reward_name : String
var reward_screen : Node

func create_reward(name : String):
	reward_name = name
	$RewardNameLabel.text = reward_name


func _on_button_pressed() -> void:
	on_reward_chosen.emit(reward_name)
