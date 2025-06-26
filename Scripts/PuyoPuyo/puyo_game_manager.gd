extends Node2D

class_name PuyoGameManager

signal board_check_delay
signal life_loss
#use chain_stage_pop for any group popping stuff as well
signal chain_stage_pop(type : Array, chain_length)
signal down_check_finished
signal turn_tick
signal player_created
signal queue_event_added(event_type : PuyoQueueEvent)
signal junk_created(amount : int)
signal chain_ended(max_chain : int)
signal junk_popped(amount : int)

#making easy references for subnodes
@onready var sound_manager : PuyoSoundManager = $PuyoSoundManager
@onready var junk_creator : JunkCreator = $JunkCreator
@onready var event_queue_manager : EventQueueManager = $EventQueueManager

#loading the grid nodes to instantiate them
@onready var grid_node_scene = preload("res://Scenes/PuyoPuyo/grid_node.tscn")
@onready var puyo_scene = preload("res://Scenes/PuyoPuyo/puyo.tscn")
@onready var puyo_pop_effect = preload("res://Scenes/effects/puyo_meaty_pop.tscn")

#number of items in each column and row. 
@export var grid_height : int = 12
@export var grid_width : int = 6
#size of the squares
@onready var square_size = ($GridBackground.texture.get_width() * $GridBackground.scale.y) / 6
#array of GridNodes (nested type declarations aren't supported unfortunately)
#grid will be column major, so [x][y] like on a grid. [column] [row]
#0,0 will be top left, and rows x,0 & x,1 will not be on screen, and are used for gameover
#just remember that we go through 0->rows then each time 0->columns + 2 (this is for stupid box)
var grid : Array = Array()
var puyos_to_pop : Array = Array()

var max_chain : int = 0
#the first puyo in the player array is the 'pivot'
var player_puyos: Array = Array()
var player_grid_positions: Array = Array()
#player rotation is right:0 down:1 left:2 up:3 
var player_rotation : int = 0
var puyo_queue : Array[Array] = []
#helps with delaying creating a player
var player_create_flag = false
#if the player shoudl be able to input
var player_input_flag = false

@export var down_tick_speed : float = 0.5
@export var player_down_speed : float = 1
#how short the player tick timer should be changed to while down is being held
@export var player_hold_down_speed : float = 0.05
var chain_length : int = 0
@export var player_slide_speed : float = 50.0
var player_next_positions : Array[Vector2] = [Vector2.ZERO, Vector2.ZERO]
var player_move_flag : bool = false

var player_fall_flag : bool = false

#this is a translation vector, not the position
var next_input_move : Vector2i = Vector2i.ZERO
var next_grid_positions : Array[Vector2i]

##used for testing and debugging
var player_test_create_flag = false
@export var test_fill_height = 0
func _ready():
	sound_manager.set_volume(0.55)
	event_queue_manager.start_flag = false
	initialize_grid()
	
	#initializing new subnodes
	junk_creator.junk_initialize(puyo_scene, grid)
	 
	#event_queue.append(PuyoQueueEvent.create(PuyoQueueEvent.EVENT_TYPE.JUNKRANDOM, 3))
	#start_game()

func start_game():
	event_queue_manager.start_flag = true
	fill_grid(test_fill_height) ##remove when finishing with testing
	fill_puyo_queue()
	await get_tree().create_timer(0.7).timeout
	grid_state_check()
	#await board_check_delay
	#player_test_create_flag = true

func end_game():
	event_queue_manager.start_flag = false
	$PlayerDownTimer.stop()
	#resetting grid
	for i in range(0, grid_width):
		for j in range(0, grid_height):
			if grid[i][j].puyo != null:
				grid[i][j].puyo.queue_free()
			grid[i][j].reset()
	puyos_to_pop = Array()
	for i in player_puyos:
		i.queue_free()
	player_puyos = Array()
	player_grid_positions = Array()
	player_rotation = 0
	for i in puyo_queue:
		for j in i:
			j.queue_free()
	puyo_queue = []
	player_create_flag = false
	player_input_flag = false
	chain_length = 0
	next_input_move = Vector2i.ZERO
	
	event_queue_manager.reset_queue()

func _physics_process(delta: float) -> void:
	if player_input_flag:
		if Input.is_action_just_pressed("puyo_left"):
			next_input_move = Vector2i.LEFT
			next_grid_positions = [(player_grid_positions[0] + next_input_move), (player_grid_positions[1] + next_input_move)]
			if check_next_move(next_grid_positions):
				player_snap_move(next_grid_positions)
		elif Input.is_action_just_pressed("puyo_right"):
			next_input_move = Vector2i.RIGHT
			next_grid_positions = [(player_grid_positions[0] + next_input_move), (player_grid_positions[1] + next_input_move)]
			if check_next_move(next_grid_positions):
				player_snap_move(next_grid_positions)
		elif Input.is_action_just_pressed("puyo_rotate"):
			player_rotate()
		elif Input.is_action_just_pressed("puyo_down"):
			$PlayerDownTimer.start(player_hold_down_speed)
		elif Input.is_action_just_released("puyo_down"):
			$PlayerDownTimer.set_wait_time(player_down_speed)
	
	if player_test_create_flag:
		if Input.is_action_just_pressed("TESTING_player_spawn"):
			create_player_puyo()
			player_test_create_flag = false
	
	#this doesn't look super awesome so its not used atm
	if player_move_flag and player_puyos != null and player_puyos.size() > 0:
		for i in range(0, 2):
			player_puyos[i].position = player_puyos[i].position.lerp(player_next_positions[i], delta * player_slide_speed)
			if player_puyos[i].position == player_next_positions[i]:
				player_move_flag  = false

func fill_grid(how_full : int):
	for i in range(0, grid_width):
		for j in range(grid_height - how_full, grid_height):
			var puyo : Puyo = puyo_scene.instantiate()
			var node_to_fill : GridNode = grid[i][j]
			node_to_fill.add_child(puyo)
			node_to_fill.set_puyo(puyo)
			node_to_fill.set_type(randi_range(2,5))
			
	#comment this out when not testing junk
	#for i in range(0, grid_width):
		#var puyo : Puyo = puyo_scene.instantiate()
		#var node_to_fill : GridNode = grid[i][1]
		#node_to_fill.add_child(puyo)
		#node_to_fill.set_puyo(puyo)
		#node_to_fill.set_type(Puyo.PUYO_TYPE.JUNK)

#initialises the grid and gives all of the nodes their neighbours
func initialize_grid():
	#fill the array with empty gridnodes
	grid.resize(grid_width)
	for i in range(0, grid_width):
		grid[i]=Array()
		grid[i].resize(grid_height)
		##we want this to be + 2 for the two rows of nodes off-screen at the top
		for j in range(0, grid_height):
			#create a row of new nodes and add them to a temporary array
			var new_node : GridNode = grid_node_scene.instantiate()
			grid[i][j] = new_node
			new_node.grid_index = Vector2i(i, j)
			#setting it's position
			new_node.position = Vector2(i * (square_size / 2), j * (square_size / 2))
			add_child(new_node)
		#add a full column 
	
	#set the top two rows to out of bounds
	#for i in range(0, grid_width):
		#for j in range(0, 2):
			#grid[i][j].is_out_of_play = true
			##this is just for testing for visual aid
			#grid[i][j].set_test_sprite(true)
	
	#setting all the neighbours for each GridNode
	for i in range(0, grid_width):
		for j in range(0, grid_height):
			set_node_neighbours(grid[i][j])

#neighbour assignment helper, takes a position in the grid, finds it's node, then fills its neighbour array
func set_node_neighbours(grid_node : GridNode):
	#look at above
	if grid_node.y > 0:
		grid_node.neighbours.append(grid[grid_node.x][grid_node.y - 1])
	#look at right
	if grid_node.x < grid_width - 1:
		grid_node.neighbours.append(grid[grid_node.x + 1][grid_node.y])
	#look at below
	if grid_node.y < grid_height - 1:
		grid_node.neighbours.append(grid[grid_node.x][grid_node.y + 1])
	#look at left
	if grid_node.x > 0:
		grid_node.neighbours.append(grid[grid_node.x - 1][grid_node.y])
	pass

#state machine for grid updating.  called whenever a puyo is placed
func grid_state_check():
	down_tick()
	await down_check_finished
	player_fall_flag = false
	var puyo_groups = get_grouped_puyos()
	if puyo_groups.size() > 0:
		await check_board(puyo_groups)
		await grid_state_check()
		chain_ended.emit(max_chain)
		max_chain = 0
		chain_length = 0
	else:
		#this next part should be done by the queue manager
		if (event_queue_manager.process_queue()):
			grid_state_check()
		

#move a puyo from one node to another. overwrites node_to's puyo. used only for resting puyos
func move_puyo(node_from : GridNode, node_to : GridNode):
	var puyo_from = node_from.puyo
	node_from.remove_child(puyo_from)
	node_from.reset()
	node_to.add_child(puyo_from)
	node_to.move_puyo(puyo_from)
	#node_to.puyo.set_pos(position_from)
	#node_to.puyo.puyo_lerp(node_to.position)
	pass

#called whenever we need to check the board. will return an array of groups of nodes (for now)
func get_grouped_puyos() -> Array:
	#down tick should always be called first to make sure board is in a valid state
	#down_tick()
	#await down_check_finished
	#any groups of 4+ blocks get 
	var groups : Array = Array()
	#go through every node in the grid
	for i in range(0, grid_width):
		for j in range(0, grid_height):
			var node_to_check : GridNode = grid[i][j]
			
			#skip iteration if node has already been checked
			if (node_to_check.is_checked):
				continue
			
			#check node recursively
			var node_group : Array = Array()
			node_group = check_node(node_to_check, node_group)
			
			#if the group is large enough, save it to the groups
			if (node_group.size() >= 4):
				groups.append(node_group)
			
			#set all nodes in the group as checked
			for n in range(node_group.size()):
				node_group[n].is_checked = true
			
	#set all nodes in the group as unchecked
	for i in range(0, grid_width):
		for j in range(0, grid_height):
			grid[i][j].is_checked = false
	#down_tick()
	return groups

#called when a tick for gravity needs to be checked, callls itself if it changed anything
func down_tick() -> bool:
	var to_move : Array = []
	#sets a check to see if anything changed, if it hasn't changed it should stay false
	var check = false
	if player_fall_flag == false:
		await get_tree().create_timer(0.2).timeout
	#loops through all puyos, but from bottom up
	for i in range(grid_height - 2, -1, -1):
		#starts with one above bottom
		for j in range(grid_width - 1, -1, -1):
			var empty_puyo_count = 0
			#if there is space below the puyo in the grid, anywhere
			if grid[j][i].is_holding_puyo:
				for k in range(i + 1, grid_height):
					if !(grid[j][k].is_holding_puyo):
						empty_puyo_count += 1
			if empty_puyo_count > 0:
				to_move.append([grid[j][i], grid[j][i + empty_puyo_count]])
				check = true
	
	if check:
		for i : Array in to_move:
			move_puyo(i[0], i[1])
		#await get_tree().create_timer(down_tick_speed).timeout
		down_tick()
	else:
		player_create_flag = true
		down_check_finished.emit()
	return check

func check_node(node_to_check: GridNode, node_group: Array, puyo_type:= Puyo.PUYO_TYPE.UNDEFINED) -> Array:
	#if node is already checked, or doesn't have a puyo, exit iteration
	if (node_group.has(node_to_check)) or (!node_to_check.is_holding_puyo):
		return node_group
	
	#if node is junk, exit iteration
	if (node_to_check.get_type() == Puyo.PUYO_TYPE.JUNK):
		return node_group
	
	#if puyo_type is undefined, this is the first iteration and we should set puyo_type
	if (puyo_type == Puyo.PUYO_TYPE.UNDEFINED):
		puyo_type = node_to_check.get_type()
	
	#if the node's puyo type doesn't match, exit iteration
	if (node_to_check.get_type() != puyo_type):
		return node_group
	
	#add the node to the group, then recursively check neighbours
	node_group.append(node_to_check)
	for i in range(0, node_to_check.neighbours.size()):
		var neighbour_to_check = node_to_check.neighbours[i]
		var updated_group: Array = check_node(neighbour_to_check, node_group, puyo_type)
		node_group = updated_group
	
	#send the accumulated list back up the recursion
	return node_group

func pop_puyos(puyo_groups:Array = puyos_to_pop):
	var junk_popped_now = 0
	if puyo_groups.is_empty():
		pass
	for group in puyo_groups:
		if group.is_empty():
			continue
		else:
			pass
		for pop_node : GridNode in group:
			var new_pop_effect = puyo_pop_effect.instantiate()
			if pop_node.puyo != null:
				new_pop_effect.start(pop_node.puyo.puyo_type)
			add_child(new_pop_effect)
			if new_pop_effect != null:
				new_pop_effect.global_position.x = pop_node.puyo.global_position.x + (square_size / 2)
				new_pop_effect.global_position.y = pop_node.puyo.global_position.y + (square_size / 2)
				new_pop_effect.restart()
			for junk_neighbours : GridNode in pop_node.neighbours:
				if junk_neighbours.get_type() == Puyo.PUYO_TYPE.JUNK:
					junk_popped_now += 1
					junk_neighbours.puyo.pop()
					junk_neighbours.reset()
			pop_node.puyo.pop()
			pop_node.reset()
	junk_popped.emit(junk_popped_now)
	puyos_to_pop = Array()

#starts a board check loop. puyo groups is an array of arrays of gridnodes
func check_board(puyo_groups : Array) -> bool:
	if puyo_groups.is_empty():
		#chain_length = 0
		board_check_delay.emit()
		return false
	else:
		chain_length += 1
		max_chain += 1
		for i in puyo_groups:
			for j in i:
				j.puyo.play_blink()
		await get_tree().create_timer(0.5).timeout
		chain_stage_pop.emit(puyo_groups, chain_length)
		down_tick()
		await down_check_finished
		pop_puyos(puyo_groups)
		#down_tick()
		#await down_check_finished
		await get_tree().create_timer(0.2).timeout
		check_board(get_grouped_puyos())
		return true

#creates player puyo
func create_player_puyo():
	if !(await loss_check()):
		player_puyos = puyo_queue.pop_front()
		fill_puyo_queue()
		add_child(player_puyos[0])
		add_child(player_puyos[1])
		player_puyos[0].add_to_group("Puyos")
		player_puyos[1].add_to_group("Puyos")
		
		player_puyos[0].connect("reached_bottom", play_puyo_thud)
		
		player_rotation = 0
		
		player_grid_positions = [Vector2i((round(grid_width -1)/ 2),0), Vector2i((round(grid_width -1)/ 2) + 1,0)]
		player_puyos[0].position.x = grid[round(grid_width / 2)][0].position.x + round(square_size / 2)
		player_puyos[1].position.x  = grid[(round(grid_width / 2)) + 1][0].position.x + square_size
		player_next_positions[0] = player_puyos[0].position
		player_next_positions[1] = player_puyos[1].position
		
		var position_check = player_grid_positions
		var end_flag = false
		if !(check_next_move(player_grid_positions)):
			for i in range(0, grid_width - 1):
				position_check = [Vector2i(i, 0), Vector2i(i + 1, 0)]
				if (check_next_move(position_check)):
					end_flag = true
					break
			if end_flag == false:
				life_loss.emit()
				#return
		player_snap_move(position_check)
		
		$PlayerDownTimer.set_wait_time(player_down_speed)
		$PlayerDownTimer.start()
		player_created.emit()
		player_input_flag = true

#returns true if next move is valid
func check_next_move(potential_next_grid_positions: Array) -> bool:
	for pos in potential_next_grid_positions:
		if (pos.x > grid_width - 1) or (pos.x < 0) or (pos.y > grid_height - 1) or (pos.y < 0):
			return false
		if grid[pos.x][pos.y].is_holding_puyo:
			return false
	return true

#assumes move being given to it is valid
func player_move(new_grid_positions: Array):
	for i in range (0, 2):
		var moving_puyo : Puyo = player_puyos[i]
		var translation_difference = new_grid_positions[i] - player_grid_positions[i]
		translation_difference *= square_size
		player_next_positions[i].x = moving_puyo.position.x + (translation_difference.x * 2)
		player_next_positions[i].y = moving_puyo.position.y + (translation_difference.y * 2)
		#moving_puyo.position.x += translation_difference.x * 2
		#moving_puyo.position.y += translation_difference.y * 2
	player_grid_positions = new_grid_positions
	player_move_flag = true

func player_snap_move(new_grid_positions: Array):
	if new_grid_positions.size() < 1 or player_puyos.size() < 1:
		return
	else:
		for i in range (0, 2):
			var moving_puyo : Puyo = player_puyos[i]
			var translation_difference = new_grid_positions[i] - player_grid_positions[i]
			translation_difference *= (square_size / 2)
			player_next_positions[i].x = moving_puyo.position.x + (translation_difference.x * 2)
			player_next_positions[i].y = moving_puyo.position.y + (translation_difference.y * 2)
			moving_puyo.position = player_next_positions[i]
		player_grid_positions = new_grid_positions
		player_move_flag = false

#connected to the timer via signal
func player_down_tick():
	var next_moves : Array[Vector2i] = []
	var to_play_drop_anims : Array[Puyo] = []
	for player_position in player_grid_positions:
		next_moves.append(Vector2i(player_position.x, player_position.y + 1))
	if check_next_move(next_moves):
		player_snap_move(next_moves)
	else:# if player shouldn't be able to move, turn it into part of the grid
		#this should probably be part of grid_updater
		player_input_flag = false
		$PlayerDownTimer.stop()
		play_puyo_thud()
		for i in range(0,2):
			var new_puyo_base = player_puyos[i]
			var new_puyo_position = Vector2(player_grid_positions[i])
			var node_to_fill = grid[new_puyo_position.x][new_puyo_position.y]
			var new_puyo : Puyo = puyo_scene.instantiate()
			new_puyo.set_type(new_puyo_base.get_type())
			new_puyo.add_to_group("Puyos")
			node_to_fill.add_child(new_puyo)
			node_to_fill.set_puyo(new_puyo)
			if (!(check_next_move([next_moves[i]]))) or player_rotation == 1 or player_rotation == 3:
				to_play_drop_anims.append(node_to_fill.puyo)
			player_puyos[i].queue_free()
		player_puyos.clear()
		player_fall_flag = false
		grid_state_check()
		turn_tick.emit()
		for i in to_play_drop_anims:
			i.play_drop_animation()

func player_rotate():
	if player_grid_positions.size() < 1:
		return
	var rotation_check : int = (player_rotation + 1) % 4
	#find wehre the rotated puyo would be
	var position_check : Vector2i
	if rotation_check == 0: #now pointing right
		position_check = player_grid_positions[0] + Vector2i(1,0)
	elif rotation_check == 1: #now pointing down
		position_check = player_grid_positions[0] +Vector2i(0,1)
	elif rotation_check == 2: #now pointing left
		position_check = player_grid_positions[0] +Vector2i(-1,0)
	else: # now pointing up
		position_check = player_grid_positions[0] +Vector2i(0,-1)
	
	var move_check : Array[Vector2i] = [player_grid_positions[0], position_check]
	var rotate_flag = true
	#now we check if we need to move the puyo pivot based on other things
	if rotation_check == 0: #now pointing right
		if !(check_next_move(move_check)): #if the new rotated vector would be invalid
			for i in range(0, move_check.size()):
				move_check[i].x -= 1
			if (check_next_move(move_check)): #if moving both puyos one to the left would be valid
				player_rotation = rotation_check
			else:
				rotate_flag = false
		else:
			player_rotation = rotation_check
	elif rotation_check == 1: #now pointing down
		if !(check_next_move(move_check)):
			for i in range(0, move_check.size()):
				move_check[i].y -= 1
			if (check_next_move(move_check)):
				player_rotation = rotation_check
				$PlayerDownTimer.start()
			else:
				rotate_flag = false
		else:
			player_rotation = rotation_check
	elif rotation_check == 2: #now pointing left
		if !(check_next_move(move_check)):
			for i in range(0, move_check.size()):
				move_check[i].x += 1
			if (check_next_move(move_check)):
				player_rotation = rotation_check
			else:
				rotate_flag = false
		else:
			player_rotation = rotation_check
	else: # now pointing up
		if !(check_next_move(move_check)):
			for i in range(0, move_check.size()):
				move_check[i].y += 1
			if (check_next_move(move_check)):
				player_rotation = rotation_check
			else:
				rotate_flag = false
		else:
			player_rotation = rotation_check
	if rotate_flag:
		player_snap_move(move_check)
	else:
		print("cant rotate")

func fill_puyo_queue():
	while puyo_queue.size() <= 2:
		var new_puyos = [puyo_scene.instantiate(), puyo_scene.instantiate()]
		#grab a random item from the puyopool
		var puyo_types = $PuyoPoolManager.get_puyo_pair()
		new_puyos[0].set_type(puyo_types[0])
		new_puyos[1].set_type(puyo_types[1])
		puyo_queue.append(new_puyos)
	#update visual puyos
	$QueuedPuyos/FirstPair1.set_type(puyo_queue[0][0].puyo_type)
	$QueuedPuyos/FirstPair2.set_type(puyo_queue[0][1].puyo_type)
	$QueuedPuyos/SecondPair1.set_type(puyo_queue[1][0].puyo_type)
	$QueuedPuyos/SecondPair2.set_type(puyo_queue[1][1].puyo_type)

#called whenever a player would be created. if they can't be created, lose the game
func loss_check() -> bool:
	if grid[int (grid_width / 2) - 1][0].is_holding_puyo:
		down_tick()
		await down_check_finished
		if grid[int (grid_width / 2) - 1][0].is_holding_puyo:
			if grid[int (grid_width / 2) - 1][0].puyo.puyo_type == Puyo.PUYO_TYPE.JUNK:
				grid[int (grid_width / 2) - 1][0].puyo.pop()
				grid[int (grid_width / 2) - 1][0].reset()
			else:
				life_loss.emit()
				return true
	return false

func add_to_spawn_queue(new_event: PuyoQueueEvent):
	queue_event_added.emit(new_event)
	event_queue_manager.add_event(new_event)

#used for specific junk patterns that fall from the top
func create_junk_specific(junk_positions : Array[Vector2i]):
	junk_creator.create_junk_specific(junk_positions)

func create_junk_row(junk_amount: int):
	junk_creator.create_junk_row(junk_amount)

func create_junk_random(junk_num: int):
	junk_creator.create_junk_random(junk_num)

func replace_junk_specific(junk_positions : Array[Vector2i]):
	junk_creator.replace_junk_specific(junk_positions)

func junk_slam(junk_amount : int):
	junk_creator.junk_slam(junk_amount)

func replace_color(color_to_replace, to_replace_with):
	junk_creator.replace_color(color_to_replace, to_replace_with)

func play_puyo_thud():
	sound_manager.play_puyo_thud()
	#$SFXPlayer.set_volume_db(linear_to_db(0.9))

func delete_player():
	player_input_flag = false
	$PlayerDownTimer.stop()
	for i in player_puyos:
		i.queue_free()
	player_puyos.clear()
	player_fall_flag = false

func get_free_spaces_left() -> int:
	var count = 0
	for i in range(0,grid_height):
		for j in range(0, grid_width):
			if grid[j][i].is_holding_puyo == false:
				count += 1
	return count

func add_certain_puyo(type : Puyo.PUYO_TYPE):
	$PuyoPoolManager.add_certain_puyo(type)

func set_volume(num : float):
	sound_manager.set_volume(num)

##TEMPORARY SIGNAL CONNECTIONS

func _on_junk_creator_junk_created(amount: int) -> void:
	junk_created.emit(amount)

func _on_event_end_game() -> void:
	down_tick()
	await down_check_finished
	end_game()
	pass # Replace with function body.
