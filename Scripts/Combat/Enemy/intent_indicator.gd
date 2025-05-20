class_name EnemyIntentIndicator
extends Node

var intent_sprite_dictionary = {
	EnemyAttack.EnemyAttackType.DROP_RANDOM : "res://Placeholder Art/map_node_images/shop_location.png",
	EnemyAttack.EnemyAttackType.DROP_ROW : "res://Placeholder Art/map_node_images/enemy_location.png",
	EnemyAttack.EnemyAttackType.REPLACE_BOTTOM : "res://Placeholder Art/puyo_out_of_bounds.png",
	EnemyAttack.EnemyAttackType.REPLACE_BOTTOM_ROW : "res://Placeholder Art/map_node_images/boss_location.png",
	EnemyAttack.EnemyAttackType.RAISE_BOTTOM : "res://Placeholder Art/puyo_out_of_bounds.png",
	EnemyAttack.EnemyAttackType.RAISE_ROW_BOTTOM : "res://Placeholder Art/puyo_out_of_bounds.png",
	EnemyAttack.EnemyAttackType.REPLACE_RED : "res://Placeholder Art/puyo_red.png",
	EnemyAttack.EnemyAttackType.REPLACE_BLUE : "res://Placeholder Art/puyo_blue.png",
	EnemyAttack.EnemyAttackType.REPLACE_GREEN : "res://Placeholder Art/puyo_green.png",
	EnemyAttack.EnemyAttackType.REPLACE_YELLOW : "res://Placeholder Art/puyo_yellow.png",
	EnemyAttack.EnemyAttackType.REPLACE_CIRCLE_RANDOM : "res://Placeholder Art/puyo_out_of_bounds.png"
}

func set_indicator(attack: EnemyAttack, attack_timer: int) -> void:
	if attack.number_of_swings > 1:
		$Container/Damage.text = str(attack.damage) + " X " + str(attack.number_of_swings)
	else:
		$Container/Damage.text = str(attack.damage)
	
	$Container/TypeIndicator.texture = load(intent_sprite_dictionary[attack.attack_type])
	
	$Container/Turns.text = str(attack_timer)
