extends Node2D

@export var spell_manager: SpellManager
@onready var reward_choice_scene : PackedScene = preload("res://Scenes/RewardScreen/reward_choice.tscn")

var pause_delay_flag = false

var equipped_spell_containers : Array[RewardChoice] = []

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("toggle_pause") and pause_delay_flag:
		pause_delay_flag = false
		get_tree().paused = false
		reset_pause_screen()

func on_game_paused():
	$PauseMenu.show()
	await get_tree().create_timer(0.05).timeout
	print("game paused")
	pause_delay_flag = true
	fill_spell_screen()

func fill_spell_screen():
	if spell_manager.equipped_spells.size() == 0:
		$PauseMenu/PageTabs/Spells/NoSpellsLabel.show()
		return
	else:
		$PauseMenu/PageTabs/Spells/NoSpellsLabel.hide()
		
	var equipped_spells : Array[SpellData] = []
	for spell in spell_manager.equipped_spells:
		equipped_spells.append(spell.spell_data)
	
	for spell_data in equipped_spells:
		var spell_reward_visual : RewardChoice = reward_choice_scene.instantiate()
		spell_reward_visual.create_reward(Reward.create_spell_reward(spell_data))
		spell_reward_visual.turn_off_button()
		equipped_spell_containers.append(spell_reward_visual)
		$PauseMenu/PageTabs/Spells.add_child(spell_reward_visual)
		spell_reward_visual.size_flags_horizontal = Control.SIZE_EXPAND_FILL

func reset_pause_screen():
	$PauseMenu.hide()
	for i in range(0, equipped_spell_containers.size()):
		var spell_holder = equipped_spell_containers[i]
		spell_holder.queue_free()
		equipped_spell_containers[i] = null
	equipped_spell_containers = []
		
