extends Node2D

@export var relic_holder : Node
@export var spell_manager: SpellManager
@export var relic_manager : RelicManager
@onready var reward_choice_scene : PackedScene = preload("res://Scenes/RewardScreen/reward_choice.tscn")
@onready var relic_button_scene : PackedScene = preload("res://Scenes/relic_button.tscn")

var pause_delay_flag = false

var equipped_spell_containers : Array[RewardChoice] = []

var equipped_relic_data : Array[RelicData] = []
var relic_buttons : Array[RelicButton] = []

func _ready() -> void:
	#spell_manager = get_node("/root/Combat/SpellManager")
	relic_manager = get_node("/root/Combat/RelicManager")

func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("toggle_pause") and pause_delay_flag:
		pause_delay_flag = false
		get_tree().paused = false
		relic_holder.show_relic_holder()
		reset_pause_screen()

func on_game_paused():
	$PauseMenu.show()
	await get_tree().create_timer(0.05).timeout
	#print("game paused")
	pause_delay_flag = true
	fill_spell_screen()
	fill_relic_screen()
	$PauseMenu/VolumeSlider.set_audio_value()

func fill_spell_screen():
	if spell_manager.equipped_spells.size() == 0:
		$PauseMenu/PageTabs/Emotions/NoSpellsLabel.show()
		return
	else:
		$PauseMenu/PageTabs/Emotions/NoSpellsLabel.hide()
		
	var equipped_spells : Array[SpellData] = []
	for spell in spell_manager.equipped_spells:
		equipped_spells.append(spell.spell_data)
	
	for spell_data in equipped_spells:
		var spell_reward_visual : RewardChoice = reward_choice_scene.instantiate()
		spell_reward_visual.create_reward(Reward.create_spell_reward(spell_data))
		spell_reward_visual.turn_off_button()
		equipped_spell_containers.append(spell_reward_visual)
		$PauseMenu/PageTabs/Emotions.add_child(spell_reward_visual)
		spell_reward_visual.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var empty_slots = 3 - equipped_spells.size()
	for i in range(0, empty_slots):
		var empty_reward : RewardChoice = reward_choice_scene.instantiate()
		empty_reward.create_empty_spell_reward()
		empty_reward.turn_off_button()
		equipped_spell_containers.append(empty_reward)
		$PauseMenu/PageTabs/Emotions.add_child(empty_reward)
		empty_reward.size_flags_horizontal = Control.SIZE_EXPAND_FILL

func fill_relic_screen():
	$PauseMenu/PageTabs/Sensations/RelicDescription.text = "Choose a sensation to reflect on"
	$PauseMenu/PageTabs/Sensations/RelicFlavor.text = ""
	$PauseMenu/PageTabs/Sensations/RelicName.text = ""
	for relic : RelicData in relic_manager.equipped_relics:
		equipped_relic_data.append(relic)
	
	if equipped_relic_data.size() <= 0:
		$PauseMenu/PageTabs/Sensations/NoRelicsLabel.show()
		return
	else:
		$PauseMenu/PageTabs/Sensations/NoRelicsLabel.hide()
	
	for relic_data :RelicData in equipped_relic_data:
		var new_button : RelicButton = relic_button_scene.instantiate()
		new_button.initialize(relic_data)
		new_button.on_relic_selected.connect(_on_relic_selected)
		new_button.size_flags_stretch_ratio = TextureRect.STRETCH_KEEP
		new_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		new_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		$PauseMenu/PageTabs/Sensations/RelicGrid.add_child(new_button)
		relic_buttons.append(new_button)

func reset_pause_screen():
	$PauseMenu.hide()
	for i in range(0, equipped_spell_containers.size()):
		var spell_holder = equipped_spell_containers[i]
		spell_holder.queue_free()
		equipped_spell_containers[i] = null
	equipped_spell_containers = []
	for i in range(0, equipped_relic_data.size()):
		var relic_holder = relic_buttons[i]
		relic_holder.queue_free()
		relic_buttons[i] = null
	equipped_relic_data = []
	relic_buttons = []

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_relic_selected(relic : RelicData):
	$PauseMenu/PageTabs/Sensations/RelicDescription.text = relic.description
	$PauseMenu/PageTabs/Sensations/RelicFlavor.text = relic.flavor_text
	$PauseMenu/PageTabs/Sensations/RelicName.text = relic.name
