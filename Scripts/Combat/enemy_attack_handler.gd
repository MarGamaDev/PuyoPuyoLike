extends Node

class_name EnemyAttackHandler

static var grid_width = 6
static var grid_height = 12

static var nodes_to_check : Array[Vector2i] = []
static var center_for_sort : Vector2i = Vector2i.ZERO

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
#REPLACE_YELLOW, REPLACE_CIRCLE_RANDOM, REPLACE_RANDOM
#has a var called damage

static func process_attack(attack_damage : int, enemy_attack : EnemyAttack) -> PuyoQueueEvent:
	var attack_type : EnemyAttack.EnemyAttackType = enemy_attack.attack_type
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
			print("circle target")
			var new_positions : Array[Vector2i] = create_circle_positions(enemy_attack.circle_target, attack_damage)
			return PuyoQueueEvent.create(PuyoQueueEvent.EVENT_TYPE.JUNK_REPLACE, 1, new_positions)
		EnemyAttack.EnemyAttackType.REPLACE_RANDOM:
			print("replace random")
			var new_positions : Array[Vector2i] = generate_random_replace_attack_positions(attack_damage)
			print(new_positions)
			return PuyoQueueEvent.create(PuyoQueueEvent.EVENT_TYPE.JUNK_REPLACE, 1, new_positions)
			#return PuyoQueueEvent.create()
		_:
			print("no enemy attack type defined?")
	return PuyoQueueEvent.create()

static func create_circle_positions(circle_center : Vector2i, junk_amount : int) -> Array[Vector2i]:
	var positions_to_fill : Array[Vector2i] = []
	nodes_to_check = []
	##FIRST: get the depth of the recrusion
	var t_calc : float
	t_calc = (2.0 + sqrt(-4.0 + ( 8.0 * float(junk_amount) ))) / 4.0
	var traversal_count : int
	if is_equal_approx(t_calc, roundf(t_calc)):
		traversal_count = int(t_calc)
	else:
		print("its a little off")
		traversal_count = int(t_calc) + 1
	print("traversal count %s" % traversal_count)
	
	##SECOND: find possible positions
	find_nodes_around_center(circle_center, traversal_count)
	positions_to_fill = nodes_to_check
	##THIRD: reduce damage amount accosrdingly
	var damage_reduction : int = positions_to_fill.size() - junk_amount
	if (damage_reduction > 0):
		if  damage_reduction > positions_to_fill.size():
			damage_reduction = positions_to_fill.size()
		center_for_sort = circle_center
		positions_to_fill.sort_custom(farthest_from_center_sort)
		for i in range(0, damage_reduction):
			positions_to_fill.pop_back()
	center_for_sort = Vector2i.ZERO
	return positions_to_fill

static func find_nodes_around_center(node_check : Vector2i, traversal_count):
	var grid_x = node_check.x
	var grid_y = node_check.y
	nodes_to_check.append(node_check)
	if traversal_count <= 1:
		return 
	else:
		if check_node_validity(node_check.x + 1, node_check.y):
			find_nodes_around_center(Vector2i(node_check.x + 1, node_check.y), traversal_count - 1)
		if check_node_validity(node_check.x - 1, node_check.y):
			find_nodes_around_center(Vector2i(node_check.x - 1, node_check.y), traversal_count - 1)
		if check_node_validity(node_check.x, node_check.y + 1):
			find_nodes_around_center(Vector2i(node_check.x, node_check.y + 1), traversal_count - 1)
		if check_node_validity(node_check.x, node_check.y - 1):
			find_nodes_around_center(Vector2i(node_check.x, node_check.y - 1), traversal_count - 1)
	pass

static func check_node_validity(width_check : int, height_check : int) -> bool:
	var flag = true
	if (width_check < 0) or (width_check >= grid_width):
		flag = false
	if (height_check < 0) or (height_check >= grid_height):
		flag = false
	if nodes_to_check.has(Vector2i(width_check, height_check)):
		flag = false
	return flag

static func farthest_from_center_sort(vector_a : Vector2i, vector_b : Vector2i) -> bool:
	var a_distance = absf(center_for_sort.distance_to(vector_a))
	var b_distance = absf(center_for_sort.distance_to(vector_b))
	if a_distance <= b_distance:
		return true
	else:
		return false

static func generate_random_replace_attack_positions(junk_amount : int) -> Array[Vector2i]:
	var positions_to_fill : Array[Vector2i] = []
	for i in range(0, junk_amount):
		var new_position_check_flag = true
		var new_position : Vector2i
		while new_position_check_flag:
			new_position = Vector2i(randi_range(0, grid_width - 1), randi_range(0, grid_height - 1))
			if positions_to_fill.has(new_position) == false:
				positions_to_fill.append(new_position)
				new_position_check_flag = false
	return positions_to_fill
