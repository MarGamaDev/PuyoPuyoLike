extends Control

class_name RewardChoice

signal on_reward_chosen(reward : Reward)

var reward_screen : Node

var reward : Reward

func create_reward(new_reward: Reward):
	reward = new_reward
	if reward.reward_type == Reward.REWARD_TYPE.SPELL:
		create_spell_reward()
	else:
		create_item_reward()

func create_spell_reward():
	var spell : SpellData = reward.spell_data
	$RewardNameLabel.text = spell.spell_name
	$RewardTypeLabel.text = "Spell - %s" % spell.type_text[spell.recipe_type]
	$SpellContainer.create_spell_container(spell, true)
	$SpellContainer.show()
	$RewardDescriptionLabel.text = spell.spell_description
	

func create_item_reward():
	pass

func _on_button_pressed() -> void:
	on_reward_chosen.emit(reward)


func _on_button_mouse_entered() -> void:
	$ItemImage/AnimationPlayer.play("itemHover")


func _on_button_mouse_exited() -> void:
	$ItemImage/AnimationPlayer.play_backwards("itemHover")
