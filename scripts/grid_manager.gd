extends Node2D

signal board_check_delay

#loading the grid nodes to instantiate them
@onready var grid_node_scene = load("res://Scenes/grid_node.tscn")
@onready var puyo_scene = load("res://Scenes/puyo.tscn")

#number of items in each column and row. 
@export var grid_height : int = 12
@export var grid_width : int = 6
#size of the squares
@export var square_size : int = 30
#array of GridNodes (nested type declarations aren't supported unfortunately)
#grid will be column major, so [x][y] like on a grid. [column] [row]
#0,0 will be top left, and rows x,0 & x,1 will not be on screen, and are used for gameover
#just remember that we go through 0->rows then each time 0->columns + 2 (this is for stupid box)
var grid : Array = Array()
var puyos_to_pop : Array = Array()

#the first puyo in the player array is the 'pivot'
var player_puyos: Array = Array()
var player_grid_positions: Array = Array()
#player rotation is right:0 down:1 left:2 up:3 
var player_rotation : int = 0
var puyo_queue : Array[Array] = []
#helps with delaying creating a player
var player_create_flag = false

@export var down_tick_speed : float = 0.1
@export var player_down_speed : float = 0.4
var chain_length : int = 0

#this is a translation vector, not the position
var next_input_move : Vector2i = Vector2i.ZERO
var next_grid_positions : Array[Vector2i]

func _ready():
	$PlayerDownTimer.set_wait_time(player_down_speed)
	initialize_grid()
	fill_grid(12)
	fill_puyo_queue()
	await get_tree().create_timer(0.7).timeout
	#calling this initiates a board check and allows chaining
	check_board(get_grouped_puyos())
	await board_check_delay
	create_player_puyo()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("puyo_left"):
		next_input_move = Vector2i.LEFT
		next_grid_positions = [(player_grid_positions[0] + next_input_move), (player_grid_positions[1] + next_input_move)]
		if check_next_move(next_grid_positions):
			player_move(next_grid_positions)
	elif Input.is_action_just_pressed("puyo_right"):
		next_input_move = Vector2i.RIGHT
		next_grid_positions = [(player_grid_positions[0] + next_input_move), (player_grid_positions[1] + next_input_move)]
		if check_next_move(next_grid_positions):
			player_move(next_grid_positions)
	elif Input.is_action_just_pressed("puyo_rotate"):
		player_rotate()
	elif Input.is_action_just_pressed("puyo_down"):
		print("down press")
	elif Input.is_action_just_released("puyo_down"):
		print("down release")

func fill_grid(how_full : int):
	for i in range(0, grid_width):
		for j in range(grid_height - how_full, grid_height):
			var puyo : Puyo = puyo_scene.instantiate()
			var node_to_fill : GridNode = grid[i][j]
			node_to_fill.add_child(puyo)
			node_to_fill.set_puyo(puyo)
			node_to_fill.set_type(randi_range(2,5))
			

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
			new_node.position = Vector2(i * square_size, j * square_size)
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
	await down_tick()
	var puyo_groups = await get_grouped_puyos()
	if puyo_groups.size() > 0:
		await check_board(puyo_groups)
		await down_tick()
		await grid_state_check()
	else:
		create_player_puyo()

#move a puyo from one node to another. overwrites node_to's puyo. used only for resting puyos
func move_puyo(node_from : GridNode, node_to : GridNode):
	var puyo_from = node_from.puyo
	node_from.remove_child(puyo_from)
	node_from.reset()
	node_to.add_child(puyo_from)
	node_to.set_puyo(puyo_from)
	pass

#called whenever we need to check the board. will return an array of groups of nodes (for now)
func get_grouped_puyos() -> Array:
	#down tick should always be called first to make sure board is in a valid state
	down_tick()
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
				print(node_group.size())
				groups.append(node_group)
			
			#set all nodes in the group as checked
			for n in range(node_group.size()):
				node_group[n].is_checked = true
			
	print(str("found ", groups.size(), " groups"))
	#set all nodes in the group as unchecked
	for i in range(0, grid_width):
		for j in range(0, grid_height):
			grid[i][j].is_checked = false
	down_tick()
	return groups

#called when a tick for gravity needs to be checked, callls itself if it changed anything
func down_tick() -> bool:
	#sets a check to see if anything changed, if it hasn't changed it should stay false
	var check = false
	await get_tree().create_timer(down_tick_speed).timeout
	#loops through all puyos, but from bottom up
	for i in range(0, grid_width):
		#starts with one above bottom
		for j in range(0, grid_height - 1):
			#if the space below is empty
			if !(grid[i][j + 1].is_holding_puyo) and grid[i][j].is_holding_puyo:
				#set check to false and move down
				move_puyo(grid[i][j], grid[i][j+1])
				check = true
	if check:
		await get_tree().create_timer(down_tick_speed).timeout
		down_tick()
	return check

func check_node(node_to_check: GridNode, node_group: Array, puyo_type:= Puyo.PUYO_TYPE.UNDEFINED) -> Array:
	#if node is already checked, or doesn't have a puyo, exit iteration
	if (node_group.has(node_to_check)) or (!node_to_check.is_holding_puyo):
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

func pop_puyos(puyo_groups:= puyos_to_pop):
	if puyo_groups.is_empty():
		pass
	for group in puyo_groups:
		if group.is_empty():
			continue
		for pop_node in group:
			pop_node.puyo.pop()
			pop_node.puyo.queue_free()
			pop_node.reset()
	puyos_to_pop = Array()

#starts a board check loop
func check_board(puyos_to_pop : Array) -> bool:
	if puyos_to_pop.is_empty():
		print("chain: ", chain_length)
		chain_length = 0
		board_check_delay.emit()
		return false
	else:
		chain_length += 1
		pop_puyos(puyos_to_pop)
		var down_check = true
		while down_check:
			down_check = await down_tick()
		await get_tree().create_timer(0.5).timeout
		check_board(get_grouped_puyos())
		return true

#creates player puyo
func create_player_puyo():
	
	player_puyos = puyo_queue.pop_front()
	fill_puyo_queue()
	add_child(player_puyos[0])
	add_child(player_puyos[1])
	
	player_rotation = 0
	
	player_grid_positions = [Vector2i(int ((grid_width -1)/ 2),0), Vector2i(int ((grid_width -1)/ 2) + 1,0)]
	
	player_puyos[0].global_position.x = grid[int (grid_width / 2)][0].position.x + square_size
	player_puyos[1].global_position.x  = grid[(int (grid_width / 2)) + 1][0].position.x + square_size * 2
	
	$PlayerDownTimer.set_wait_time(player_down_speed)
	$PlayerDownTimer.start()

#returns true if next move is valid
func check_next_move(next_grid_positions: Array[Vector2i]) -> bool:
	for pos in next_grid_positions:
		if (pos.x > grid_width - 1) or (pos.x < 0) or (pos.y > grid_height - 1) or (pos.y < 0):
			return false
		if grid[pos.x][pos.y].is_holding_puyo:
			return false
	return true

#assumes move being given to it is valid
func player_move(new_grid_positions: Array[Vector2i]):
	var translation_difference = new_grid_positions[0] - player_grid_positions[0]
	translation_difference *= square_size
	for moving_puyo in player_puyos:
		moving_puyo.global_position.x += translation_difference.x * 2
		moving_puyo.global_position.y += translation_difference.y * 2
	player_grid_positions = new_grid_positions

#connected to the timer via signal
func player_down_tick():
	var next_moves : Array[Vector2i] = []
	for player_position in player_grid_positions:
		next_moves.append(Vector2i(player_position.x, player_position.y + 1))
	if check_next_move(next_moves):
		player_move(next_moves)
	else:# if player shouldn't be able to move, turn it into part of the grid
		$PlayerDownTimer.stop()
		for i in range(0,2):
			var new_puyo_base = player_puyos[i]
			var new_puyo_position = Vector2(player_grid_positions[i])
			var node_to_fill = grid[new_puyo_position.x][new_puyo_position.y]
			var new_puyo : Puyo = puyo_scene.instantiate()
			new_puyo.set_type(new_puyo_base.get_type())
			node_to_fill.add_child(new_puyo)
			node_to_fill.set_puyo(new_puyo)
			player_puyos[i].queue_free()
		player_puyos.clear()
		down_tick()
		await get_tree().create_timer(0.2).timeout
		grid_state_check()

func player_rotate():
	var rotation_check : int = (player_rotation + 1) % 4
	var new_rotation_check : Vector2i
	#the puyo pair rotates around a pivot so we only need to check the validity of rotating
	##DO THIS WITH MAR BC I DONT WANNA WASTE A BUNCH OF TIME TRYING TO REMEMBER VECTOR MATHS
	pass

func fill_puyo_queue():
	while puyo_queue.size() <= 2:
		var new_puyos = [puyo_scene.instantiate(), puyo_scene.instantiate()]
		#grab a random item from the puyopool
		var puyo_types = PlayerData.get_puyo_pool().pick_random()
		new_puyos[0].set_type(puyo_types[0])
		new_puyos[1].set_type(puyo_types[1])
		puyo_queue.append(new_puyos)
		print("2 pairs away:",new_puyos[0].get_type(), " ", new_puyos[1].get_type())
	#update visual puyos
	$QueuedPuyos/FirstPair1.set_type(puyo_queue[0][0].puyo_type)
	$QueuedPuyos/FirstPair2.set_type(puyo_queue[0][1].puyo_type)
	$QueuedPuyos/SecondPair1.set_type(puyo_queue[1][0].puyo_type)
	$QueuedPuyos/SecondPair2.set_type(puyo_queue[1][1].puyo_type)
