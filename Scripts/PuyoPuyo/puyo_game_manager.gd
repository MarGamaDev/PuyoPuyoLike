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
signal update_puyo_pool(puyos : Array[Array])

#making easy references for subnodes
@onready var sound_manager : PuyoSoundManager = $PuyoSoundManager
@onready var junk_creator : JunkCreator = $JunkCreator
@onready var event_queue_manager : EventQueueManager = $EventQueueManager
@onready var player_manager : PlayerPuyoManager = $PlayerPuyoManager

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

var chain_length : int = 0
var max_chain : int = 0

@export var down_tick_speed : float = 0.5

var junk_wait_flag : bool = false

##used for testing and debugging
var player_test_create_flag = false
@export var test_fill_height = 0

func _ready():
	sound_manager.set_volume(0.55)
	event_queue_manager.start_flag = false
	initialize_grid()
	
	#initializing new subnodes
	junk_creator.junk_initialize(puyo_scene, grid)
	player_manager.player_puyo_initialize(grid, square_size, puyo_scene)

func start_game():
	event_queue_manager.start_flag = true
	fill_grid(test_fill_height) ##remove when finishing with testing
	player_manager.fill_puyo_queue()
	await get_tree().create_timer(0.7).timeout
	grid_state_check()
	#await board_check_delay
	#player_test_create_flag = true

func end_game():
	event_queue_manager.start_flag = false
	player_manager.player_down_timer.stop()
	player_manager.reset_player()
	#resetting grid
	for i in range(0, grid_width):
		for j in range(0, grid_height):
			if grid[i][j].puyo != null:
				grid[i][j].puyo.queue_free()
			grid[i][j].reset()
	puyos_to_pop = Array()
	chain_length = 0
	event_queue_manager.reset_queue()
	
	#this doesn't look super awesome so its not used atm
	#if player_move_flag and player_puyos != null and player_puyos.size() > 0:
		#for i in range(0, 2):
			#player_puyos[i].position = player_puyos[i].position.lerp(player_next_positions[i], delta * player_slide_speed)
			#if player_puyos[i].position == player_next_positions[i]:
				#player_move_flag  = false

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
			new_node.position = Vector2(i * (square_size / 2), j * (square_size / 2))
			add_child(new_node)
		#add a full column 
	
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
	#player_fall_flag = false
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
	return groups

#called when a tick for gravity needs to be checked, callls itself if it changed anything
func down_tick() -> bool:
	var to_move : Array = []
	#sets a check to see if anything changed, if it hasn't changed it should stay false
	var check = false
	#if player_fall_flag == false:
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
		player_manager.player_create_flag = true
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
		#await down_check_finished
		await get_tree().create_timer(0.2).timeout
		check_board(get_grouped_puyos())
		return true

#creates player puyo

#returns true if next move is valid
func check_next_move(potential_next_grid_positions: Array) -> bool:
	for pos in potential_next_grid_positions:
		if (pos.x > grid_width - 1) or (pos.x < 0) or (pos.y > grid_height - 1) or (pos.y < 0):
			return false
		if grid[pos.x][pos.y].is_holding_puyo:
			return false
	return true

#update visual puyos in queue
func update_puyo_queue_visuals(puyo_queue : Array):
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

func get_free_spaces_left() -> int:
	var count = 0
	for i in range(0,grid_height):
		for j in range(0, grid_width):
			if grid[j][i].is_holding_puyo == false:
				count += 1
	return count

func get_global_position_from_grid(pos : Vector2i) -> Vector2:
	var selected_node : GridNode = grid[pos.x][pos.y]
	var node_position = selected_node.global_position
	return Vector2(node_position.x + (square_size / 2), node_position.y + (square_size / 2))

func add_certain_puyo(type : Puyo.PUYO_TYPE):
	$PlayerPuyoManager/PuyoPoolManager.add_certain_puyo(type)

func delete_player():
	player_manager.delete_player()

func get_puyo_pool():
	update_puyo_pool.emit($PlayerPuyoManager/PuyoPoolManager.get_pool())

func change_puyo_pool(pair_to_change : Array, to_change_to : Array):
	$PlayerPuyoManager/PuyoPoolManager.change_puyo_pool(pair_to_change, to_change_to)

##signal relays

func _on_junk_creator_junk_created(amount: int) -> void:
	junk_created.emit(amount)
	junk_wait_flag = true

func _on_event_end_game() -> void:
	down_tick()
	await down_check_finished
	end_game()

func _on_player_life_loss() -> void:
	life_loss.emit()

func _on_player_created() -> void:
	player_created.emit()

func _on_player_turn_tick() -> void:
	turn_tick.emit()
