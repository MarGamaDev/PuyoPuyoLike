extends Node2D

var health_addition = 0
var attack_addition = 0

@export var health_modifier : int = 3
@export var attack_modifier : int = 1
var multiplicative_scaling : float = 1
@export var multiplicative_scaling_per_rest_stop : float = 1.2

func reset_difficulty():
	health_addition = 0
	attack_addition = 0
	health_modifier = 3
	attack_modifier = 1
	multiplicative_scaling = 1.2
	EncounterTrackerForRelics.reset_tracker()

func increase_scaling_flat():
	health_addition += int(health_modifier * multiplicative_scaling)
	attack_addition += int(attack_modifier * multiplicative_scaling)
	#print("attack modifier : %s" %attack_addition)

func increase_scaling_multiplier():
	multiplicative_scaling = multiplicative_scaling * multiplicative_scaling_per_rest_stop
	#print("mult scaler : %s" %multiplicative_scaling)


func get_health_addition() -> int:
	return health_addition

func get_attack_addition() -> int:
	return attack_addition
