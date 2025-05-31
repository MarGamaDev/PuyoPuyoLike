extends Node

var rest_encounter_counter : int = 0
var mult_scaler : int = 1

func reset_tracker():
	rest_encounter_counter = 0
	mult_scaler = 1
	print("tracker reset")

func on_rest_encounter():
	rest_encounter_counter += 1
	mult_scaler = 1 + (0.5 * rest_encounter_counter)
	
