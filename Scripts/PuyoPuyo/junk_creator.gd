extends Node2D

class_name JunkCreator

##TODO connect these signals that needed to be emitted

signal junk_created(amount : int)

var puyo_scene : PackedScene
var grid : Array
var grid_height : int = 12
var grid_width : int = 6

func junk_initialize(new_puyo_scene : PackedScene, new_grid : Array):
	puyo_scene = new_puyo_scene
	grid = new_grid

#used for specific junk patterns that fall from the top
func create_junk_specific(junk_positions : Array[Vector2i]):
	junk_created.emit(junk_positions.size())
	#junk positions will be from left to right top to bottom
	for i in junk_positions:
		var junk_puyo : Puyo = puyo_scene.instantiate()
		var node_to_fill : GridNode = grid[i.x][i.y]
		if !(node_to_fill.is_holding_puyo):
			node_to_fill.add_child(junk_puyo)
			node_to_fill.set_puyo(junk_puyo)
			node_to_fill.set_type(Puyo.PUYO_TYPE.JUNK)

func create_junk_row(junk_amount: int):
	junk_created.emit(junk_amount)
	var number_of_rows : int = int(junk_amount / grid_width)
	var remaining_junk : int = junk_amount - (number_of_rows * grid_width)
	var row_offset : int = 0
	
	if remaining_junk != 0:
		row_offset = 1
		for j in range(0, remaining_junk):
			var junk_puyo : Puyo = puyo_scene.instantiate()
			var node_to_fill : GridNode = grid[j][0]
			if !(node_to_fill.is_holding_puyo):
					node_to_fill.add_child(junk_puyo)
					node_to_fill.set_puyo(junk_puyo)
					node_to_fill.set_type(Puyo.PUYO_TYPE.JUNK)
	for i in range(row_offset, number_of_rows + row_offset):
		for j in range(0, grid_width):
			var junk_puyo : Puyo = puyo_scene.instantiate()
			var node_to_fill : GridNode = grid[j][i]
			if !(node_to_fill.is_holding_puyo):
					node_to_fill.add_child(junk_puyo)
					node_to_fill.set_puyo(junk_puyo)
					node_to_fill.set_type(Puyo.PUYO_TYPE.JUNK)

func create_junk_random(junk_num: int):
	var junk_positions : Array[Vector2i] = []
	var junk_amount = 0
	#need to make sure there's enough spaces to spawn the junk
	for grid_i in range(0, grid_width):
		for grid_j in range(0, grid_height):
			if !(grid[grid_i][grid_j].is_holding_puyo):
				junk_amount += 1
	#if theres more spaces left than the number, spawn that many, otherwise fill the spaces
	if junk_amount > junk_num:
		junk_amount = junk_num
	for i in range (0, junk_amount):
		var new_position = Vector2i(randi_range(0, grid_width - 1), 0)
		var spawn_check = true
		while spawn_check:
			#if !(grid[new_position.x][new_position.y].is_holding_puyo):
				##if the randomly selected space holds a puyo already
				##reset height, since it can't go lower in that column, and try a different column
				#new_position = Vector2i(randi_range(0, grid_width), 0)
			if junk_positions.has(new_position):
				#if the position is already in the array of junks to create
				new_position.y += 1 #try to go below it
			else: #if this position is free in both the array and the grid
				junk_positions.append(new_position)
				spawn_check = false
	#call the specific method to spawn these junks
	create_junk_specific(junk_positions)

func replace_junk_specific(junk_positions : Array[Vector2i]):
	junk_created.emit(junk_positions.size())
	#junk positions will be from left to right top to bottom
	for i in junk_positions:
		var junk_puyo : Puyo = puyo_scene.instantiate()
		var node_to_fill : GridNode = grid[i.x][i.y]
		if !(node_to_fill.is_holding_puyo):
			node_to_fill.add_child(junk_puyo)
			node_to_fill.set_puyo(junk_puyo)
		node_to_fill.set_type(Puyo.PUYO_TYPE.JUNK)
		node_to_fill.puyo.become_junk()

func junk_slam(junk_amount : int):
	var number_of_rows : int = int(junk_amount / grid_width)
	var remaining_junk : int = junk_amount - (number_of_rows * grid_width)
	
	#finding where teh rows should be, which is lowest row of puyos with non-junk puyos in it
	var no_rows_check = true
	var lowest_row = 0
	for i in range(number_of_rows - 1, grid_height):
		if i != -1:
			var row_check = false
			for j in range(0, grid_width):
				if (grid[j][i].is_holding_puyo and grid[j][i].puyo.puyo_type != Puyo.PUYO_TYPE.JUNK) or !(grid[j][i].is_holding_puyo):
					row_check = true
			if row_check and i > lowest_row:
				lowest_row = i
				no_rows_check = false
	if no_rows_check:
		lowest_row = grid_height - 1

	#replace these rows with junk
	var junk_array : Array[Vector2i]= []
	for i in range(lowest_row, lowest_row - number_of_rows, -1):
		for j in range(0, grid_width):
			junk_array.append(Vector2i(j, i))
	
	if remaining_junk > 0:
		var remaining_junk_row = lowest_row - number_of_rows
		if remaining_junk_row >= 0:
			for j in range(0, remaining_junk):
				junk_array.append(Vector2i(j, remaining_junk_row))
	
	replace_junk_specific(junk_array)

func replace_color(color_to_replace, to_replace_with):
	if to_replace_with == Puyo.PUYO_TYPE.JUNK:
		junk_created.emit()
	for i in range(0, grid_height):
		for j in range(0, grid_width):
			var node_to_check : GridNode = grid[j][i]
			if node_to_check.is_holding_puyo and node_to_check.puyo.puyo_type == color_to_replace:
				node_to_check.puyo.set_type(to_replace_with)
				if to_replace_with == Puyo.PUYO_TYPE.JUNK:
					node_to_check.puyo.become_junk()
