extends Node2D

var health_addition = 0
var attack_addition = 0

@export var health_modifier : int = 3
@export var attack_modifier : int = 0.5
var multiplicative_scaling : float = 0.5
@export var multiplicative_scaling_per_rest_stop : float = 1.25

func reset_difficulty():
	health_addition = 0
	attack_addition = 0
	health_modifier = 3
	attack_modifier = 1
	multiplicative_scaling = 0.5
	EncounterTrackerForRelics.reset_tracker()

func increase_scaling_flat():
	health_addition += int(health_modifier * multiplicative_scaling)
	attack_addition += int(attack_modifier * multiplicative_scaling)

func increase_scaling_multiplier():
	multiplicative_scaling = multiplicative_scaling * multiplicative_scaling_per_rest_stop

func get_health_addition() -> int:
	return health_addition

func get_attack_addition() -> int:
	return attack_addition
