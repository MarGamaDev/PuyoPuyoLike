extends Node2D
class_name SpellManager

signal all_clear_for_next_encounter()
signal on_spell_cast(spell_length : int, spell_name : String)

@export var test_spell : SpellData
@export var test_spell_2 : SpellData
@export var test_spell_3 :SpellData
@export var sound_manager : SoundManager
@onready var equipped_spells : Array[SpellNode] = []
@onready var spell_corresponding_rewards : Array[Reward] = []

var chain_stage_tracker : int = 0

var awaiting_spell_data_holder : SpellData
var awaiting_reward : Reward

func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("TESTING_player_spawn"):
		#test_add_spell(test_spell)
		pass

func add_spell(spell_data: SpellData, reward: Reward):
	if equipped_spells.size() >= 3 or spell_data == null:
		print("too many spells!")
		$SpellChoiceMenu.show()
		awaiting_spell_data_holder = spell_data
		awaiting_reward = reward
		$SpellChoiceMenu.handle_spell_selection(equipped_spells)
	else:
		var spell_node : SpellNode
		spell_node = load(SpellFinder.find_spell(spell_data.spell_name)).instantiate()
		add_child(spell_node)
		
		spell_node.setup_spell_node(spell_data)
		equipped_spells.append(spell_node)
		spell_corresponding_rewards.append(reward)
		var spell_container  : SpellContainer = $EquippedSpellsContainer.add_spell(spell_data)
		spell_container.play_spell_progress_noise.connect(play_spell_progress_noise)
		spell_node.on_spell_progressed.connect(spell_container.progress_spell_visual)
		spell_node.on_spell_progress_reset.connect(spell_container.reset_recipe_visual)
		spell_node.on_spell_complete.connect(spell_container.on_spell_complete)
		spell_node.on_spell_complete.connect(spell_container.play_effect)
		spell_node.on_spell_complete.connect(spell_cast)
		spell_node.update_enemy_damage_visuals.connect(update_enemy_visual_damage_queue)
		spell_node.connect_to_effect_signals()
		spell_node.link_to_contianer(spell_container.get_marker())
		all_clear_for_next_encounter.emit()

func block_spell_check(puyo_array : Array, chain_length : int):
	if equipped_spells.size() < 1:
		return
	
	for i in equipped_spells:
		i.process_block(puyo_array, chain_length)

func on_player_turn_taken_spell_reset():
	$EquippedSpellsContainer.all_spell_reset()
	for i in equipped_spells:
		i.spell_reset()

func reset_spell_visuals():
	$EquippedSpellsContainer.all_spell_reset()

func spell_to_remove_selected(index: int):
	$EquippedSpellsContainer.remove_spell(index)
	var to_remove = equipped_spells[index]
	equipped_spells.remove_at(index)
	##currently re-adds spells to pool
	spell_corresponding_rewards[index].has_been_taken = false
	spell_corresponding_rewards.remove_at(index)
	to_remove.queue_free()
	$SpellChoiceMenu.hide()
	add_spell(awaiting_spell_data_holder, awaiting_reward)
	pass

func spell_cast(spell_length : int, spell_name : String):
	print("spell cast")
	on_spell_cast.emit(spell_length, spell_name)

func test_add_spell(spell_data: SpellData):
		var spell_node : SpellNode
		spell_node = load(SpellFinder.find_spell(spell_data.spell_name)).instantiate()
		add_child(spell_node)
		
		spell_node.setup_spell_node(spell_data)
		equipped_spells.append(spell_node)
		var spell_container = $EquippedSpellsContainer.add_spell(spell_data)
		spell_node.on_spell_progressed.connect(spell_container.progress_spell_visual)
		spell_node.on_spell_progressed.connect(play_spell_progress_noise)
		spell_node.on_spell_progress_reset.connect(spell_container.reset_recipe_visual)
		spell_node.on_spell_complete.connect(spell_container.on_spell_complete)
		spell_node.on_spell_complete.connect(spell_cast)
		spell_node.update_enemy_damage_visuals.connect(update_enemy_visual_damage_queue)
		spell_node.connect_to_effect_signals()
		spell_node.link_to_contianer(spell_container.get_marker())

#may not need this later
func update_enemy_visual_damage_queue():
	var combat_manager : CombatManager = get_node("/root/Combat")
	for enemy : Enemy in combat_manager.enemies:
		print("damage_should_be_updating")
		enemy.update_damage_visually()

func play_spell_progress_noise():
	print("test sfx")
	sound_manager.spell_build_up_play()
	pass
