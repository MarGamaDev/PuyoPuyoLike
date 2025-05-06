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
