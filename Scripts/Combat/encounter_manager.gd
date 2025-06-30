extends Node2D
class_name EncounterManager

signal on_update_encounter(encounter: Encounter)
signal on_rest_stop()
signal on_boss_encounter

var boss_folder_paths : Array[String] = ["res://Scenes/Combat/Encounters/BossEncounters/EasyBossEncounters/", "res://Scenes/Combat/Encounters/BossEncounters/MediumBossEncounters/", "res://Scenes/Combat/Encounters/BossEncounters/HardBossEncounters/"]
var normal_encounter_folder_paths : Array[String] = ["res://Scenes/Combat/Encounters/NormalEncounters/EasyEncounters/", "res://Scenes/Combat/Encounters/NormalEncounters/MediumEncounters/", "res://Scenes/Combat/Encounters/NormalEncounters/HardEncounters/"]

@export var encounter_label : RichTextLabel
var easy_encounters : PackedStringArray
var medium_encounters: PackedStringArray
var hard_encounters: PackedStringArray
var easy_bosses : PackedStringArray
var medium_bosses : PackedStringArray
var hard_bosses : PackedStringArray
var boss_encounter_array : PackedStringArray
var bosses : Array[Array]
var encounters : Array[Array]
var current_encounter : Encounter
@export var encounters_between_rest_stops : int = 3
var rest_stop_check : int

var rest_stop_count : int = 0
@export var rest_stops_where_difficulty_changes: Array[int] = [2,5]
var current_difficulty : int = 0

@export var test_encounter : PackedScene

var first_encounter_flag = true

@export var test_battle : BattleData
@onready var current_battle : Battle = $CurrentBattle
var current_battle_encounter_tracker : int = 0

func _ready():
	current_battle.initialize_from_battle_data(test_battle)
	rest_stop_check = encounters_between_rest_stops
	preload_encounter_lists()

func preload_encounter_lists():
	easy_encounters = ResourceLoader.list_directory(normal_encounter_folder_paths[0])
	medium_encounters = ResourceLoader.list_directory(normal_encounter_folder_paths[1])
	hard_encounters = ResourceLoader.list_directory(normal_encounter_folder_paths[2])
	easy_bosses = ResourceLoader.list_directory(boss_folder_paths[0])
	medium_bosses = ResourceLoader.list_directory(boss_folder_paths[1])
	hard_bosses = ResourceLoader.list_directory(boss_folder_paths[2])
	encounters = [easy_encounters, medium_encounters, hard_encounters]
	bosses = [easy_bosses, medium_bosses, hard_bosses]
	pass

func load_next_encounter(boss_flag := false):
	#encounter_label.show()
	if current_encounter != null:
		current_encounter.queue_free()
	var next_encounter 
	
	print("current battle index: %s" % current_battle_encounter_tracker)
	print(current_battle.enemy_waves.size())
	next_encounter = current_battle.enemy_waves[current_battle_encounter_tracker]
	load_encounter(next_encounter, boss_flag)

func load_encounter(next_encounter, boss_flag):
	#if test_encounter != null:
		#next_encounter = test_encounter
	#else:
		#if first_encounter_flag:
			#next_encounter = load("res://Scenes/Combat/Encounters/NormalEncounters/EasyEncounters/basic_single_grunt_encounter.tscn")
			#first_encounter_flag = false
		#else:
			#next_encounter = load(get_encounter(boss_flag))
	current_encounter = next_encounter.instantiate()
	add_child(current_encounter)
	await current_encounter.on_encounter_initialized
	on_update_encounter.emit(current_encounter)
	encounter_label.show()
	if rest_stop_check == 1:
		encounter_label.text = "Next reward after this boss!"
	else:
		encounter_label.text = "Next reward in " + str(rest_stop_check) + " waves!"

func _on_wave_beat():
	current_battle_encounter_tracker += 1
	if current_battle_encounter_tracker >= current_battle.enemy_waves.size():
		current_battle_encounter_tracker = 0
		print("current battle complete")
	print("current battle index after fight: %s" % current_battle_encounter_tracker)
	load_next_encounter(false)


func check_for_rest_stop():
	rest_stop_check -= 1
	if rest_stop_check == 0:
		rest_stop_check = encounters_between_rest_stops
		on_rest_stop.emit()
		DifficultyManager.increase_scaling_multiplier()
		rest_stop_count += 1
		encounter_label.hide()
		#encounter_label.text = "Next up: grunts"
	elif rest_stop_check == 1:
		#print("boss time!")
		#encounter_label.text == "Next up: reward"
		load_next_encounter(true)
		DifficultyManager.increase_scaling_flat()
	else:
		load_next_encounter()
		DifficultyManager.increase_scaling_flat()
	if rest_stop_check == 2:
		#encounter_label.text = "Next up: Boss!"
		pass

func get_encounter(boss_flag := false):
	if current_difficulty < rest_stops_where_difficulty_changes.size():
		if rest_stop_count >= rest_stops_where_difficulty_changes[current_difficulty]:
			current_difficulty += 1
			#print("difficulty up")
	var difficulty_chooser = 0
	match current_difficulty:
		0:
			difficulty_chooser = 0
		1:
			if randi_range(0, 1) == 0:
				difficulty_chooser = 0
			else:
				difficulty_chooser = 1
			if boss_flag:
				difficulty_chooser = 1
		2:
			if randi_range(0, 1) == 0:
				difficulty_chooser = 1
			else:
				difficulty_chooser = 2
	if boss_flag:
		on_boss_encounter.emit()
		return (boss_folder_paths[difficulty_chooser] + bosses[difficulty_chooser][randi_range(0, bosses[difficulty_chooser].size() - 1)])
	else:
		return (normal_encounter_folder_paths[difficulty_chooser] + encounters[difficulty_chooser][randi_range(0, encounters[difficulty_chooser].size() - 1)])
