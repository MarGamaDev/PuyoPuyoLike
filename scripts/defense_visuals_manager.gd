extends Node2D
class_name DefenseVisualsManager

func update_shield_visuals(new_shield : int):
	$TestCounters/TestShieldLabel.text = "Shield: %s" % new_shield

func update_counter_visuals(new_counter : int):
	$TestCounters/TestCounterLabel.text = "Counter: %s" % new_counter
