extends Control

class_name RewardChoice

signal on_reward_chosen(reward : Reward)

var reward_screen : Node

var reward : Reward

func create_reward(new_reward: Reward):
	reward = new_reward
	$RewardNameLabel.text = reward.reward_name
	if new_reward.reward_type == Reward.REWARD_TYPE.SPELL:
		$RewardNameLabel.text = reward.spell_data.spell_name
		$RewardTypeLabel.text = "Spell - %s" % reward.spell_data.type_text[reward.spell_data.recipe_type]
		#$SpellContainer.create_spell_container(reward.spell_data, true)
		$SpellContainer.show()
	else:
		$RewardTypeLabel.text = "Item"
		$ItemImage.show()
	$RewardDescriptionLabel.text = reward.reward_description


func _on_button_pressed() -> void:
	on_reward_chosen.emit(reward)


func _on_button_mouse_entered() -> void:
	$ItemImage/AnimationPlayer.play("itemHover")


func _on_button_mouse_exited() -> void:
	$ItemImage/AnimationPlayer.play_backwards("itemHover")
