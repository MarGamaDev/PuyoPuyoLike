extends CanvasLayer

signal on_reward_chosen(type: RewardChoice.REWARD_TYPE, name : String)
signal restart_combat_after_reward()

@onready var rewards_container : HBoxContainer = $Background/RewardsContainer
@onready var reward_choice_scene : PackedScene = preload("res://Scenes/reward_choice.tscn")

@export var possible_rewards : Array[String]

@export var reward_choice_pool_size : int = 3
var reward_choices : Array
var choice_containers : Array

func _ready():
	#generate_pool()
	pass

func generate_pool(new_pool_size := reward_choice_pool_size):
	await get_tree().create_timer(0.4).timeout
	show()
	reward_choice_pool_size = new_pool_size
	reward_choices = []
	choice_containers = []
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
		var new_reward_choice : RewardChoice = reward_choice_scene.instantiate()
		new_reward_choice.connect("on_reward_chosen", on_reward_button_pressed)
		new_reward_choice.connect("on_reward_chosen", reset_pool)
		##will need to change this to draw on a pool
		new_reward_choice.create_reward(RewardChoice.REWARD_TYPE.ITEM, i)
		$RewardsContainer.add_child(new_reward_choice)
		choice_containers.append(new_reward_choice)

func reset_pool(name : String):
	for i in choice_containers:
		i.queue_free()
	reward_choices = []
	choice_containers = []

@warning_ignore("shadowed_variable_base_class")
func on_reward_button_pressed(type: RewardChoice.REWARD_TYPE, name : String):
	print(name + " chosen!")
	on_reward_chosen.emit(type, name)
	restart_combat_after_reward.emit()
	hide()
	reset_pool(name)
