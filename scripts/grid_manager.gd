extends Node2D

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

func _ready():
	initialize_grid()
	fill_grid()
	get_grouped_puyos()

func fill_grid():
	for i in range(0, grid_width):
		for j in range(2, grid_height):
			var puyo : Puyo = puyo_scene.instantiate()
			var node_to_fill : GridNode = grid[i][j]
			node_to_fill.set_puyo(puyo)
			node_to_fill.set_type(randi_range(2,5))
			node_to_fill.add_child(puyo)
		
	

#initialises the grid and gives all of the nodes their neighbours
func initialize_grid():
	#fill the array with empty gridnodes
	grid.resize(grid_width)
	for i in range(0, grid_width):
		grid[i]=Array()
		grid[i].resize(grid_height + 2)
		##we want this to be + 2 for the two rows of nodes off-screen at the top
		for j in range(0, grid_height + 2):
			#create a row of new nodes and add them to a temporary array
			var new_node : GridNode = grid_node_scene.instantiate()
			grid[i][j] = new_node
			new_node.grid_index = Vector2i(i, j)
			#setting it's position
			new_node.position = Vector2(i * square_size, j * square_size)
			add_child(new_node)
		#add a full column 
	
	#set the top two rows to out of bounds
	for i in range(0, grid_width):
		for j in range(0, 2):
			grid[i][j].is_out_of_play = true
			#this is just for testing for visual aid
			grid[i][j].set_test_sprite(true)
	
	#setting all the neighbours for each GridNode
	for i in range(0, grid_width):
		for j in range(0, grid_height):
			set_node_neighbours(grid[i][j])

#neighbour assignment helper, takes a position in the grid, finds it's node, then fills its neighbour array
func set_node_neighbours(grid_node : GridNode):
	#look at above
	if grid_node.y > 2:
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

#move a puyo from one node to another. overwrites node_to's puyo
func move_puyo(node_from : GridNode, node_to : GridNode):
	node_to.set_puyo(node_from.puyo)
	node_from.reset()
	pass

#called whenever we need to check the board. will return an array of groups of nodes (for now)
func get_grouped_puyos() -> Array:
	#any groups of 4+ blocks get 
	var groups : Array = Array()
	#go through every node in the grid
	for i in range(0, grid_width):
		##LATER we want to ignore the nodes on top ( for now ) so we start at 2
		for j in range(2, grid_height):
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
	return groups

#called when a tick for gravity needs to be checked, callls itself if it changed anything
func down_tick():
	#sets a check to see if anything changed
	var check = true
	#loops through all puyos, but from bottom up
	for i in range(0, grid_width):
		#starts with one above bottom
		for j in range(0, grid_height + 1):
			#if the space below is empty
			if !(grid[i][j + 1].is_holding_puyo) and grid[i][j].is_holding_puyo:
				#set check to false and move down
				move_puyo(grid[i][j], grid[i][j+1])
				down_tick()

		
func check_node(node_to_check: GridNode, node_group: Array, puyo_type:= Puyo.PUYO_TYPE.UNDEFINED) -> Array:
	#print("checking node ", node_to_check.grid_index)
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
