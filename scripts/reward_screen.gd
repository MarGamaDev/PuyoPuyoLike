extends Node

signal on_reward_chosen(name : String)

@onready var rewards_container : HBoxContainer = $Background/RewardsContainer
@onready var reward_choice_scene : PackedScene = preload("res://Scenes/reward_choice.tscn")

@export var possible_rewards : Array[String]

@export var reward_choice_pool_size : int = 3
var reward_choices : Array

func _ready():
	generate_pool()

func generate_pool(new_pool_size := reward_choice_pool_size):
	reward_choice_pool_size = new_pool_size
	reward_choices = []
	var reward_check = true
	for i in range(0, reward_choice_pool_size):
		var new_item_for_pool = possible_rewards.pick_random()
		while reward_check:
			new_item_for_pool = possible_rewards.pick_random()
			print(reward_choices.has(new_item_for_pool))
			if !(reward_choices.has(new_item_for_pool)):
				reward_check = false
		reward_check = true
		reward_choices.append(new_item_for_pool)
	
	for i in reward_choices:
		var new_reward_choice : Reward = reward_choice_scene.instantiate()
		new_reward_choice.connect("on_reward_chosen", on_reward_button_pressed)
		##will need to change this
		new_reward_choice.create_reward(i)
		$RewardsContainer.add_child(new_reward_choice)

func on_reward_button_pressed(name: String):
	print(name + " chosen!")
	on_reward_chosen.emit(name)
