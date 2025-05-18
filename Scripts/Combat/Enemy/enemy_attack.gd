class_name EnemyAttack
extends Resource
@export var damage: int
@export var number_of_swings: int
@export var number_of_turns_till_swing: int
@export var attack_type: EnemyAttackType

enum EnemyAttackType {
	DROP_RANDOM,
	DROP_ROW,
	REPLACE_BOTTOM,
	RAISE_BOTTOM,
	REPLACE_RED,
	REPLACE_BLUE,
	REPLACE_GREEN,
	REPLACE_YELLOW
}
