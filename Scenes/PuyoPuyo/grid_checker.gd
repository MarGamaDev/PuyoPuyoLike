extends Node2D

class_name GridChecker

signal board_check_delay
signal on_max_chain_increase(difference: int)

signal chain_stage_pop(type : Array, chain_length)
signal life_loss

var grid : Array
var grid_height : int = 12
var grid_width : int = 6
var chain_length : int

##TODO CHANGE THIS TO THE GRID UPDATER
@export var grid_updater : PuyoGameManager

var down_check_finished_signal

func ready():
	down_check_finished_signal = grid_updater.down_check_finished

func grid_check_initialize(new_grid : Array, new_chain_length : int):
	grid = new_grid
	chain_length = new_chain_length

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

#starts a board check loop. puyo groups is an array of arrays of gridnodes
func check_board(puyo_groups : Array) -> bool:
	if puyo_groups.is_empty():
		#chain_length = 0
		board_check_delay.emit()
		return false
	else:
		chain_length += 1
		on_max_chain_increase.emit(1)
		for i in puyo_groups:
			for j in i:
				j.puyo.play_blink()
		await get_tree().create_timer(0.5).timeout
		chain_stage_pop.emit(puyo_groups, chain_length)
		grid_updater.down_tick()
		await down_check_finished_signal
		grid_updater.pop_puyos(puyo_groups)
		grid_updater.down_tick()
		await down_check_finished_signal
		await get_tree().create_timer(0.2).timeout
		check_board(get_grouped_puyos())
		return true

#returns true if next move is valid
func check_next_move(potential_next_grid_positions: Array) -> bool:
	for pos in potential_next_grid_positions:
		if (pos.x > grid_width - 1) or (pos.x < 0) or (pos.y > grid_height - 1) or (pos.y < 0):
			return false
		if grid[pos.x][pos.y].is_holding_puyo:
			return false
	return true

#called whenever a player would be created. if they can't be created, lose the game
func loss_check() -> bool:
	if grid[int (grid_width / 2) - 1][0].is_holding_puyo:
		grid_updater.down_tick()
		await down_check_finished_signal
		if grid[int (grid_width / 2) - 1][0].is_holding_puyo:
			if grid[int (grid_width / 2) - 1][0].puyo.puyo_type == Puyo.PUYO_TYPE.JUNK:
				grid[int (grid_width / 2) - 1][0].puyo.pop()
				grid[int (grid_width / 2) - 1][0].reset()
			else:
				life_loss.emit()
				return true
	return false

func get_free_spaces_left() -> int:
	var count = 0
	for i in range(0,grid_height):
		for j in range(0, grid_width):
			if grid[j][i].is_holding_puyo == false:
				count += 1
	return count
