class_name EnemyAttack
extends Resource
@export var damage: int
@export var number_of_swings: int
@export var number_of_turns_till_swing: int
@export var attack_type: EnemyAttackType
var circle_target : Vector2i

enum EnemyAttackType {
	DROP_RANDOM,
	DROP_ROW,
	REPLACE_BOTTOM,
	REPLACE_BOTTOM_ROW,
	RAISE_BOTTOM,
	RAISE_ROW_BOTTOM,
	REPLACE_RED,
	REPLACE_BLUE,
	REPLACE_GREEN,
	REPLACE_YELLOW,
	REPLACE_CIRCLE_RANDOM,
	REPLACE_RANDOM
}
