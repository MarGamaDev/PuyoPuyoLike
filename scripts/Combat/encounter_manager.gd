extends Node2D

signal on_update_encounter(encounter: Encounter)
signal on_rest_stop()

@export var encounter_array : Array[PackedScene]
var current_encounter : Encounter
@export var encounters_between_rest_stops : int = 1
var rest_stop_counter : int

func _ready():
	rest_stop_counter = encounters_between_rest_stops

func load_next_encounter():
	if current_encounter != null:
		current_encounter.queue_free()
	var next_encounter = encounter_array[randi_range(0, encounter_array.size() - 1)]
	current_encounter = next_encounter.instantiate()
	add_child(current_encounter)
	await current_encounter.on_encounter_initialized
	on_update_encounter.emit(current_encounter)

func check_for_rest_stop():
	rest_stop_counter -= 1
	if rest_stop_counter == 0:
		rest_stop_counter = encounters_between_rest_stops
		on_rest_stop.emit()
	else:
		load_next_encounter()
