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
		create_relic_reward()

func create_spell_reward():
	var spell : SpellData = reward.spell_data
	$RewardNameLabel.text = spell.spell_name
	#$RewardTypeLabel.show()
	#$RewardTypeLabel.text = "Spell - %s" % spell.type_text[spell.recipe_type]
	$SpellContainer.create_spell_container(spell, true)
	$SpellContainer.show()
	$RewardDescriptionLabel.text = spell.spell_description
	if spell.spell_description.length() > 80:
		$RewardDescriptionLabel.add_theme_font_size_override("normal_font_size", 30)
	else:
		$RewardDescriptionLabel.add_theme_font_size_override("normal_font_size", 40)
	$FlavorTextLabel.text = spell.flavor_text
	

func create_relic_reward():
	var relic : RelicData = reward.relic_data
	$RewardNameLabel.text = relic.name
	#$RewardTypeLabel.hide()
	$RelicImage.show()
	$RelicImage.texture = relic.sprite
	$RewardDescriptionLabel.text = relic.description
	
	if relic.description.length() > 80:
		$RewardDescriptionLabel.add_theme_font_size_override("normal_font_size", 30)
	else:
		$RewardDescriptionLabel.add_theme_font_size_override("normal_font_size", 40)
	$FlavorTextLabel.text = relic.flavor_text
	pass

func create_empty_spell_reward():
	$RewardNameLabel.text = "Emotion slot empty"
	#$RewardTypeLabel.hide()
	$RelicImage.hide()
	$RewardDescriptionLabel.text = ""
	$FlavorTextLabel.text = ""

func create_empty_relic_reward():
	$RewardNameLabel.text = "Click a Sensation"
	#$RewardTypeLabel.hide()
	$RelicImage.hide()
	$SpellContainer.hide()
	$RelicImage.hide()
	$RewardDescriptionLabel.hide()
	$FlavorTextLabel.hide()
	turn_off_button()

func _on_button_pressed() -> void:
	on_reward_chosen.emit(reward)


func _on_button_mouse_entered() -> void:
	$RelicImage/AnimationPlayer.play("itemHover")


func _on_button_mouse_exited() -> void:
	$RelicImage/AnimationPlayer.play_backwards("itemHover")
	

func turn_off_button():
	$Button.hide()
