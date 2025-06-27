extends Node2D

class_name PlayerPuyoManager

signal play_thud_sfx
signal life_loss
signal player_created
signal turn_tick
signal update_queue(new_queue : Array)

##TODO change this
@export var grid_manager : PuyoGameManager
@export var grid_checker : GridChecker

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
@export var player_down_speed : float = 1
#how short the player tick timer should be changed to while down is being held
@export var player_hold_down_speed : float = 0.05
@export var player_slide_speed : float = 50.0
var player_next_positions : Array[Vector2] = [Vector2.ZERO, Vector2.ZERO]
var player_move_flag : bool = false

#this is a translation vector, not the position
var next_input_move : Vector2i = Vector2i.ZERO
var next_grid_positions : Array[Vector2i]

var grid : Array
var grid_height : int = 12
var grid_width : int = 6
var square_size
var puyo_scene : PackedScene

@onready var player_down_timer : Timer = $PlayerDownTimer

func player_puyo_initialize(new_grid : Array, grid_square_size, puyo_scene_pass : PackedScene):
	grid = new_grid
	square_size = grid_square_size
	puyo_scene = puyo_scene_pass

func reset_player():
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
	next_input_move = Vector2i.ZERO

func _physics_process(delta: float) -> void:
	if player_input_flag:
		if Input.is_action_just_pressed("puyo_left"):
			next_input_move = Vector2i.LEFT
			next_grid_positions = [(player_grid_positions[0] + next_input_move), (player_grid_positions[1] + next_input_move)]
			if grid_checker.check_next_move(next_grid_positions):
				player_snap_move(next_grid_positions)
		elif Input.is_action_just_pressed("puyo_right"):
			next_input_move = Vector2i.RIGHT
			next_grid_positions = [(player_grid_positions[0] + next_input_move), (player_grid_positions[1] + next_input_move)]
			if grid_checker.check_next_move(next_grid_positions):
				player_snap_move(next_grid_positions)
		elif Input.is_action_just_pressed("puyo_rotate"):
			player_rotate()
		elif Input.is_action_just_pressed("puyo_down"):
			player_down_timer.start(player_hold_down_speed)
		elif Input.is_action_just_released("puyo_down"):
			player_down_timer.set_wait_time(player_down_speed)

func create_player_puyo():
	if !(await grid_checker.loss_check()):
		player_puyos = puyo_queue.pop_front()
		fill_puyo_queue()
		add_child(player_puyos[0])
		add_child(player_puyos[1])
		player_puyos[0].add_to_group("Puyos")
		player_puyos[1].add_to_group("Puyos")
		
		player_puyos[0].connect("reached_bottom", play_puyo_thud_sfx)
		
		player_rotation = 0
		
		player_grid_positions = [Vector2i((round(grid_width -1)/ 2),0), Vector2i((round(grid_width -1)/ 2) + 1,0)]
		player_puyos[0].position.x = grid[round(grid_width / 2)][0].position.x + round(square_size / 2)
		player_puyos[1].position.x  = grid[(round(grid_width / 2)) + 1][0].position.x + square_size
		player_next_positions[0] = player_puyos[0].position
		player_next_positions[1] = player_puyos[1].position
		
		var position_check = player_grid_positions
		var end_flag = false
		if !(grid_checker.check_next_move(player_grid_positions)):
			for i in range(0, grid_width - 1):
				position_check = [Vector2i(i, 0), Vector2i(i + 1, 0)]
				if (grid_checker.check_next_move(position_check)):
					end_flag = true
					break
			if end_flag == false:
				life_loss.emit()
				#return
		player_snap_move(position_check)
		
		player_down_timer.set_wait_time(player_down_speed)
		player_down_timer.start()
		player_created.emit()
		player_input_flag = true

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
	if grid_checker.check_next_move(next_moves):
		player_snap_move(next_moves)
	else:# if player shouldn't be able to move, turn it into part of the grid
		##TODO this should probably be part of grid_updater
		player_input_flag = false
		$PlayerDownTimer.stop()
		play_thud_sfx.emit()
		for i in range(0,2):
			var new_puyo_base = player_puyos[i]
			var new_puyo_position = Vector2(player_grid_positions[i])
			var node_to_fill = grid[new_puyo_position.x][new_puyo_position.y]
			var new_puyo : Puyo = puyo_scene.instantiate()
			new_puyo.set_type(new_puyo_base.get_type())
			new_puyo.add_to_group("Puyos")
			node_to_fill.add_child(new_puyo)
			node_to_fill.set_puyo(new_puyo)
			if (!(grid_checker.check_next_move([next_moves[i]]))) or player_rotation == 1 or player_rotation == 3:
				to_play_drop_anims.append(node_to_fill.puyo)
			player_puyos[i].queue_free()
		player_puyos.clear()
		#player_fall_flag = false
		grid_manager.grid_state_check()
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
		if !(grid_checker.check_next_move(move_check)): #if the new rotated vector would be invalid
			for i in range(0, move_check.size()):
				move_check[i].x -= 1
			if (grid_checker.check_next_move(move_check)): #if moving both puyos one to the left would be valid
				player_rotation = rotation_check
			else:
				rotate_flag = false
		else:
			player_rotation = rotation_check
	elif rotation_check == 1: #now pointing down
		if !(grid_checker.check_next_move(move_check)):
			for i in range(0, move_check.size()):
				move_check[i].y -= 1
			if (grid_checker.check_next_move(move_check)):
				player_rotation = rotation_check
				player_down_timer.start()
			else:
				rotate_flag = false
		else:
			player_rotation = rotation_check
	elif rotation_check == 2: #now pointing left
		if !(grid_checker.check_next_move(move_check)):
			for i in range(0, move_check.size()):
				move_check[i].x += 1
			if (grid_checker.check_next_move(move_check)):
				player_rotation = rotation_check
			else:
				rotate_flag = false
		else:
			player_rotation = rotation_check
	else: # now pointing up
		if !(grid_checker.check_next_move(move_check)):
			for i in range(0, move_check.size()):
				move_check[i].y += 1
			if (grid_checker.check_next_move(move_check)):
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
	update_queue.emit(puyo_queue)

func delete_player():
	player_input_flag = false
	player_down_timer.stop()
	for i in player_puyos:
		i.queue_free()
	player_puyos.clear()
	pass


##TODO connect to the sfx machine
func play_puyo_thud_sfx():
	play_thud_sfx.emit()
