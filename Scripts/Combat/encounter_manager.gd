extends Node2D
class_name EncounterManager

signal on_update_encounter(encounter: Encounter)
signal on_rest_stop()
signal on_boss_encounter
signal advance_to_next_map_node()
signal open_win_screen()

var boss_folder_paths : Array[String] = ["res://Resources/battles/Boss Battles/Easy/", "res://Resources/battles/Boss Battles/Medium/", "res://Resources/battles/Boss Battles/Hard/"]
var battle_folder_paths : Array[String] = ["res://Resources/battles/Easy/", "res://Resources/battles/Medium/", "res://Resources/battles/Hard/"]

@export var encounter_label : RichTextLabel
var easy_battles : PackedStringArray
var medium_battles: PackedStringArray
var hard_battles: PackedStringArray
var easy_bosses : PackedStringArray
var medium_bosses : PackedStringArray
var hard_bosses : PackedStringArray
var boss_battles_array : PackedStringArray
var bosses : Array[Array]
var battles : Array[Array]
var current_encounter : Encounter
#@export var encounters_between_rest_stops : int = 3
var rest_stop_check : int

var rest_stop_count : int = 0
#@export var rest_stops_where_difficulty_changes: Array[int] = [2,5]
var current_difficulty : int = 0

@export var test_encounter : PackedScene

var first_encounter_flag = true

@export var test_battle : BattleData
@onready var current_battle : Battle = $CurrentBattle
var current_battle_encounter_tracker : int = 0

@onready var first_battle: String =  "res://Resources/battles/first_battle.tres"
var first_battle_flag : bool = true

@export var attack_test_flag : bool = false
@onready var attack_test_encounter_path : String = "res://Scenes/Combat/Encounters/TestEncounters/attack_test_encounter.tscn"

var final_fight_flag : bool = false

func preload_battle_lists():
	easy_battles = ResourceLoader.list_directory(battle_folder_paths[0])
	medium_battles = ResourceLoader.list_directory(battle_folder_paths[1])
	hard_battles = ResourceLoader.list_directory(battle_folder_paths[2])
	easy_bosses = ResourceLoader.list_directory(boss_folder_paths[0])
	medium_bosses = ResourceLoader.list_directory(boss_folder_paths[1])
	hard_bosses = ResourceLoader.list_directory(boss_folder_paths[2])
	battles = [easy_battles, medium_battles, hard_battles]
	bosses = [easy_bosses, medium_bosses, hard_bosses]
	pass


func _ready():
	#rest_stop_check = encounters_between_rest_stops
	final_fight_flag = false
	preload_battle_lists()
	first_battle_flag = true
	current_battle.initialize_from_battle_data(load(get_battle(false)))

func load_next_encounter(boss_flag := false):
	#encounter_label.show()
	if current_encounter != null:
		current_encounter.queue_free()
	var next_encounter 
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
	if attack_test_flag:
		current_encounter = load(attack_test_encounter_path).instantiate()
	else:
		current_encounter = next_encounter.instantiate()
	add_child(current_encounter)
	await current_encounter.on_encounter_initialized
	on_update_encounter.emit(current_encounter)
	#encounter_label.show()
	#if rest_stop_check == 1:
		#encounter_label.text = "Next reward after this boss!"
	#else:
		#encounter_label.text = "Next reward in " + str(rest_stop_check) + " waves!"

func start_first_encounter(boss_flag:= false):
	#first_battle_flag = true
	load_next_encounter(boss_flag)

func _on_wave_beat(boss_flag := false):
	if final_fight_flag:
		open_win_screen.emit()
		final_fight_flag = false
	else:
		current_battle_encounter_tracker += 1
		if current_battle_encounter_tracker >= current_battle.enemy_waves.size():
			current_battle_encounter_tracker = 0
			#current_difficulty += 1
			advance_to_next_map_node.emit()
		else:
			load_next_encounter(boss_flag)

func update_battle_data(boss_flag := false):
	var battle_data : BattleData = load(get_battle(boss_flag))
	current_battle.initialize_from_battle_data(battle_data)
	load_next_encounter(boss_flag)
	current_battle_encounter_tracker = 0
	DifficultyManager.increase_scaling_multiplier()

func get_battle(boss_flag := false):
	#if current_difficulty < rest_stops_where_difficulty_changes.size():
		#if rest_stop_count >= rest_stops_where_difficulty_changes[current_difficulty]:
			#current_difficulty += 1
	if first_battle_flag:
		first_battle_flag = false
		return first_battle
	var difficulty_chooser = current_difficulty
	if boss_flag:
		on_boss_encounter.emit()
		return (boss_folder_paths[difficulty_chooser] + bosses[difficulty_chooser][randi_range(0, bosses[difficulty_chooser].size() - 1)])
	else:
		return (battle_folder_paths[difficulty_chooser] + battles[difficulty_chooser][randi_range(0, battles[difficulty_chooser].size() - 1)])


func _on_map_manager_increase_difficulty_level() -> void:
	current_difficulty += 1


func _on_final_boss_fight_started() -> void:
	final_fight_flag = true
