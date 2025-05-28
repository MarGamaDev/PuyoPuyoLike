extends Node2D
class_name EncounterManager

signal on_update_encounter(encounter: Encounter)
signal on_rest_stop()

var boss_folder_path = "res://Scenes/Combat/Encounters/BossEncounters/"
var normal_encounter_folder_path = "res://Scenes/Combat/Encounters/NormalEncounters/"

@export var encounter_label : Label
@export var encounter_array : PackedStringArray
var boss_encounter_array : PackedStringArray
var current_encounter : Encounter
@export var encounters_between_rest_stops : int = 3
var rest_stop_counter : int

func _ready():
	rest_stop_counter = encounters_between_rest_stops
	preload_encounters()

func preload_encounters():
	encounter_array = ResourceLoader.list_directory(normal_encounter_folder_path)
	boss_encounter_array = ResourceLoader.list_directory(boss_folder_path)
	pass

func load_next_encounter(boss_flag := false):
	encounter_label.show()
	if current_encounter != null:
		current_encounter.queue_free()
	var next_encounter
	if boss_flag:
		next_encounter = load(boss_folder_path + boss_encounter_array[randi_range(0, boss_encounter_array.size() - 1)])
	else:
		next_encounter = load(normal_encounter_folder_path + encounter_array[randi_range(0, encounter_array.size() - 1)])
	current_encounter = next_encounter.instantiate()
	add_child(current_encounter)
	await current_encounter.on_encounter_initialized
	on_update_encounter.emit(current_encounter)

func check_for_rest_stop():
	rest_stop_counter -= 1
	if rest_stop_counter == 0:
		rest_stop_counter = encounters_between_rest_stops
		on_rest_stop.emit()
		encounter_label.hide()
		encounter_label.text = "Next up: grunts"
	elif rest_stop_counter == 1:
		print("boss time!")
		encounter_label.text == "Next up: reward"
		load_next_encounter(true)
	else:
		load_next_encounter()
	if rest_stop_counter == 2:
		encounter_label.text = "Next up: Boss!"
