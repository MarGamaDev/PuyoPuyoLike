extends Node

class_name EnemyAttackHandler

#event creator
#create(type: EVENT_TYPE = EVENT_TYPE.JUNK_RANDOM, junk_num: int = 0,
#specific_positions: Array[Vector2i] = [],
#new_color_to_change := Puyo.PUYO_TYPE.UNDEFINED,
#new_color_target := Puyo.PUYO_TYPE.UNDEFINED)

#event types
#enum EVENT_TYPE {PLAYER, JUNK_ROW, JUNK_RANDOM, JUNK_SPECIFIC,
#JUNK_REPLACE, JUNK_SLAM, COLOR_REPLACE}

#attack types
#EnemyAttackType {DROP_RANDOM, DROP_ROW, REPLACE_BOTTOM, REPLACE_BOTTOM_ROW, RAISE_BOTTOM,
#RAISE_ROW_BOTTOM, REPLACE_RED,REPLACE_BLUE, REPLACE_GREEN,
#REPLACE_YELLOW, REPLACE_CIRCLE_RANDOM
#has a var called damage

static func process_attack(attack_damage : int, attack_type : EnemyAttack.EnemyAttackType) -> PuyoQueueEvent:
	var event_type : PuyoQueueEvent.EVENT_TYPE
	match attack_type:
		EnemyAttack.EnemyAttackType.DROP_RANDOM:
			return PuyoQueueEvent.create(PuyoQueueEvent.EVENT_TYPE.JUNK_RANDOM, attack_damage)
		EnemyAttack.EnemyAttackType.DROP_ROW:
			return PuyoQueueEvent.create(PuyoQueueEvent.EVENT_TYPE.JUNK_ROW, attack_damage)
		EnemyAttack.EnemyAttackType.REPLACE_BOTTOM:
			print("REPLACE_BOTTOM doesn't exist yet/isn't used")
		EnemyAttack.EnemyAttackType.REPLACE_BOTTOM_ROW:
			return PuyoQueueEvent.create(PuyoQueueEvent.EVENT_TYPE.JUNK_SLAM, attack_damage)
		EnemyAttack.EnemyAttackType.RAISE_BOTTOM:
			print("RAISE_BOTTOM doesn't exist yet/isn't used")
		EnemyAttack.EnemyAttackType.RAISE_ROW_BOTTOM:
			print("RAISE_ROW_BOTTOM doesn't exist yet/isn't used")
		EnemyAttack.EnemyAttackType.REPLACE_RED:
			return PuyoQueueEvent.create(PuyoQueueEvent.EVENT_TYPE.COLOR_REPLACE, 0,[], Puyo.PUYO_TYPE.RED, Puyo.PUYO_TYPE.JUNK)
		EnemyAttack.EnemyAttackType.REPLACE_BLUE:
			return PuyoQueueEvent.create(PuyoQueueEvent.EVENT_TYPE.COLOR_REPLACE, 0,[], Puyo.PUYO_TYPE.BLUE, Puyo.PUYO_TYPE.JUNK)
		EnemyAttack.EnemyAttackType.REPLACE_GREEN:
			return PuyoQueueEvent.create(PuyoQueueEvent.EVENT_TYPE.COLOR_REPLACE, 0,[], Puyo.PUYO_TYPE.GREEN, Puyo.PUYO_TYPE.JUNK)
		EnemyAttack.EnemyAttackType.REPLACE_YELLOW:
			return PuyoQueueEvent.create(PuyoQueueEvent.EVENT_TYPE.COLOR_REPLACE, 0,[], Puyo.PUYO_TYPE.YELLOW, Puyo.PUYO_TYPE.JUNK)
		EnemyAttack.EnemyAttackType.REPLACE_CIRCLE_RANDOM:
			print("REPLACE_CIRCLE_RANDOM doesn't exist yet/isn't used")
		_:
			print("no enemy attack type defined?")
	return PuyoQueueEvent.create()
