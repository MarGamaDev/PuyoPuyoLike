extends CanvasLayer

signal on_reward_chosen(reward : Reward)
signal restart_combat_after_reward()
signal on_spell_reward_chosen(spell_data : SpellData)
signal on_item_reward_chosen

@onready var rewards_container : HBoxContainer = $RewardsContainer
@onready var reward_choice_scene : PackedScene = preload("res://Scenes/RewardScreen/reward_choice.tscn")

@export var reward_choice_pool_size : int = 3
var reward_choices : Array[Reward]
var choice_containers : Array[RewardChoice]

var rest_flag = true

var possible_rewards : Array[Reward]

func _ready():
	possible_rewards = get_node("/root/Combat/RewardManager").get_pool()
	pass

func generate_pool(new_pool_size := reward_choice_pool_size):
	if rest_flag:
		await get_tree().create_timer(0.4).timeout
		show()
		reward_choice_pool_size = new_pool_size
		reward_choices = []
		choice_containers = []
		var reward_check = true
		for i in range(0, reward_choice_pool_size):
			var new_item_for_pool : Reward
			while reward_check:
				new_item_for_pool = possible_rewards.pick_random()
				#print(reward_choices.has(new_item_for_pool))
				if !(reward_choices.has(new_item_for_pool)) and new_item_for_pool:
					reward_check = false
			reward_check = true
			reward_choices.append(new_item_for_pool)
		
		for i in reward_choices:
			var new_reward_choice : RewardChoice = reward_choice_scene.instantiate()
			new_reward_choice.connect("on_reward_chosen", on_reward_button_pressed)
			new_reward_choice.connect("on_reward_chosen", reset_pool)
			##will need to change this to draw on a pool
			new_reward_choice.create_reward(i)
			$RewardsContainer.add_child(new_reward_choice)
			choice_containers.append(new_reward_choice)
		
		rest_flag = false

func reset_pool(reward_unused):
	for i in choice_containers:
		i.queue_free()
	reward_choices = []
	choice_containers = []
	rest_flag = true

@warning_ignore("shadowed_variable_base_class")
func on_reward_button_pressed(reward : Reward):
	on_reward_chosen.emit(reward)
	if reward.reward_type == Reward.REWARD_TYPE.SPELL:
		on_spell_reward_chosen.emit(reward.spell_data)
	else:
		on_item_reward_chosen.emit()
	restart_combat_after_reward.emit()
	hide()
	reset_pool(reward)
