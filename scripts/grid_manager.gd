extends Node2D

#loading the grid nodes to instantiate them
@onready var grid_node_scene = load("res://Scenes/grid_node.tscn")

#number of items in each column and row. 
@export var grid_column : int = 12
@export var grid_row : int = 6
#size of the squares
@export var square_size : int = 50
#array of GridNodes (nested type declarations aren't supported unfortunately)
#grid will be column major, so [x][y] like on a grid. [column] [row]
#0,0 will be top left, and rows x,0 & x,1 will not be on screen, and are used for gameover
#just remember that we go through 0->rows then each time 0->columns + 2 (this is for stupid box)
var grid : Array[Array]

func _ready():
	grid_setup()

#initialises the grid and gives all of the nodes their neighbours
func grid_setup():
	#fill the array with empty gridnodes
	for i in range(0, grid_row):
		var temp_array : Array[GridNode] = []
		##we want this to be + 2 for the two rows of nodes off-screen at the top
		for j in range(0, grid_column + 2):
			#create a row of new nodes and add them to a temporary array
			var new_node : GridNode = grid_node_scene.instantiate()
			add_child(new_node)
			#setting it's position
			new_node.position = Vector2(i * square_size, j * square_size)
			temp_array.append(new_node)
		#add a full column 
		grid.append(temp_array)
	
	#set the top two rows to out of bounds
	for i in range(0, grid_row):
		for j in range(0, 2):
			grid[i][j].is_out_of_play = true
			#this is just for testing for visual aid
			grid[i][j].set_test_sprite(true)
	
	#setting all the neighbours for each GridNode
	for i in range(0, grid_row):
		for j in range(0, grid_column + 2):
			find_neighbours(i, j, grid[i][j])

#neighbour assignment helper, takes a position in the grid, finds it's node, then fills its neighbour array
func find_neighbours(grid_x: int, grid_y: int, grid_node : GridNode):
	#look at above
	if grid_y > 0:
		grid_node.neighbours.append(grid[grid_x][grid_y - 1])
	#look at right
	if grid_x < grid_row - 1:
		grid_node.neighbours.append(grid[grid_x + 1][grid_y])
	#look below
	if grid_y < grid_column + 1:
		grid_node.neighbours.append(grid[grid_x][grid_y + 1])
	#look at left
	if grid_x > 0:
		grid_node.neighbours.append(grid[grid_x - 1][grid_y])
	pass

#move a puyo from one node to another. overwrites node_to's puyo
func move_puyo(node_from : GridNode, node_to : GridNode):
	node_to.set_puyo(node_from.puyo)
	node_from.reset()
	pass

#called whenever we need to check the board. will return an array of groups of nodes (for now)
func board_check():
	#any groups of 4+ blocks that are found will be stored in this
	var groups : Array[Array] = []
	#go through every node in the grid
	for i in range(0, grid_row):
		##LATER we want to ignore the nodes on top ( for now ) so we start at 2
		for j in range(0, grid_column + 2):
			#get the current node
			var temp_node : GridNode = grid[i][j]
			#see if it's already in a group to be removed, and if it has a puyo and it has 1 or more neighbours
			if !(temp_node.is_checked) and (temp_node.is_holding_puyo) and (temp_node.neighbours.size() > 0):
				#create an array with out node, and call our recursive check on it
				var temp_array = [temp_node]
				#after setting the current node to being checked
				temp_node.is_checked = true
				neighbour_check(temp_array, temp_node.get_color(), temp_node)
				#if the array is less than 4 neighbours, meaning it isn't a block
				if temp_array.size() < 4:
					#set all the contents back to not being checked
					for x in temp_array:
						x.is_checked = false
				else: #if the array is greater than 3 in size
					for temp in temp_array:
						temp.set_color(0)
					#let the check status remain, and store this group in our groups array
					groups.append(temp_array)
	return groups

#recursive function for checking all neighbours
func neighbour_check(node_array: Array, color_check: int, current_node: GridNode):
	#for each neighbour the node has
	for i in range(0, current_node.neighbours.size()):
		var check = current_node.neighbours[i]
		#check its color, if its the same as the desired color AND it hasn't been checked
		if check.get_color() == color_check and !(check.is_checked):
			#set the next node to has been checked
			check.is_checked = true
			node_array.append(check)
			#do a recursive call
			neighbour_check(node_array, color_check, check)
			return node_array
	#if theres no more neighbours to check, return an empty array 
	pass
