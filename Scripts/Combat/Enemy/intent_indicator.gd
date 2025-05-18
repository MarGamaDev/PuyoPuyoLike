class_name EnemyIntentIndicator
extends Node

func set_indicator(attack: EnemyAttack, attack_timer: int) -> void:
	$Container/Damage.text = str(attack.damage) + " X " + str(attack.number_of_swings)
	# todo: update sprite for attacktype
	$Container/Turns.text = str(attack_timer)
