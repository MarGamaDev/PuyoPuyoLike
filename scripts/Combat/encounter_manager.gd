extends Node2D

signal on_update_encounter(encounter: Encounter)

@export var encounter_array : Array[PackedScene]
var current_encounter : Encounter

func load_next_encounter():
	if current_encounter != null:
		current_encounter.queue_free()
	var next_encounter = encounter_array[randi_range(0, encounter_array.size() - 1)]
	current_encounter = next_encounter.instantiate()
	add_child(current_encounter)
	await current_encounter.on_encounter_initialized
	on_update_encounter.emit(current_encounter)
