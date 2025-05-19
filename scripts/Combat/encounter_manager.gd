extends Node2D

signal update_encounter_count(count : int)

@export var encounter_array : Array[PackedScene]
var current_encounter : Encounter

func next_encounter():
	if current_encounter != null:
		remove_child(current_encounter)
	var next_encounter = encounter_array[randi_range(0, encounter_array.size() - 1)]
	current_encounter = next_encounter.instantiate()
	add_child(current_encounter)
	update_encounter_count.emit(current_encounter.enemy_count)
