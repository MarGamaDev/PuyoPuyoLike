extends CanvasLayer

signal on_reward_chosen(reward : Reward)
signal restart_combat_after_reward()
signal on_spell_reward_chosen(spell_data : SpellData)
signal on_relic_reward_chosen(relic_data : RelicData)
signal clear_board
signal on_reward_skipped

@onready var rewards_container : HBoxContainer = $RewardsContainer
@onready var reward_choice_scene : PackedScene = preload("res://Scenes/RewardScreen/reward_choice.tscn")

@export var reward_choice_pool_size : int = 3
var reward_choices : Array[Reward]
var choice_containers : Array[RewardChoice]

var rest_flag = true

var possible_rewards : Array[Reward]
var puyo_certain_relic_flag = false

func _ready():
	possible_rewards = get_node("/root/Combat/RewardManager").get_pool()
	pass

func generate_pool(new_pool_size := reward_choice_pool_size):
	clear_board.emit()
	reset_pool()
	if rest_flag:
		await get_tree().create_timer(0.4).timeout
		show()
		reward_choice_pool_size = new_pool_size
		reward_choices = []
		choice_containers = []
		var reward_check = true
		for i in range(reward_choices.size(), 3):
			var new_item_for_pool : Reward
			while reward_check:
				new_item_for_pool = possible_rewards.pick_random()
				#print(reward_choices.has(new_item_for_pool))
				if !(reward_choices.has(new_item_for_pool)) and !new_item_for_pool.has_been_taken:
					reward_check = false
				if new_item_for_pool.reward_type == Reward.REWARD_TYPE.RELIC:
					if new_item_for_pool.relic_data.is_part_of_certain_cycle and puyo_certain_relic_flag:
						reward_check = true
			reward_check = true
			reward_choices.append(new_item_for_pool)
		
		for i in reward_choices:
			var new_reward_choice : RewardChoice = reward_choice_scene.instantiate()
			new_reward_choice.connect("on_reward_chosen", on_reward_button_pressed)
			new_reward_choice.connect("on_reward_chosen", reset_pool)
			new_reward_choice.create_reward(i)
			$RewardsContainer.add_child(new_reward_choice)
			choice_containers.append(new_reward_choice)
		
		rest_flag = false

func reset_pool(reward_unused = null):
	for i in choice_containers:
		i.queue_free()
	reward_choices = []
	choice_containers = []
	rest_flag = true

@warning_ignore("shadowed_variable_base_class")
func on_reward_button_pressed(reward : Reward):
	if reward.reward_type != Reward.REWARD_TYPE.SPELL:
		reward.has_been_taken = true
	on_reward_chosen.emit(reward)
	if reward.reward_type == Reward.REWARD_TYPE.SPELL:
		on_spell_reward_chosen.emit(reward.spell_data, reward)
	else:
		on_relic_reward_chosen.emit(reward.relic_data)
	hide()
	reset_pool()

func on_skip_button_pressed():
	hide()
	reset_pool()
	on_reward_chosen.emit(null)
	on_reward_skipped.emit()
