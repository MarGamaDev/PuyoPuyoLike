extends Node2D

class_name Puyo

signal reached_bottom

##types are junk: 0, blue : 1, green : 2, red : 3, yellow : 4
enum PUYO_TYPE {UNDEFINED, JUNK, BLUE, GREEN, RED, YELLOW}
var puyo_type : PUYO_TYPE = PUYO_TYPE.UNDEFINED
#junk status (i.e. is a junk or not)
var is_junk : bool = false
#if a puyo is part of an 'active' pair (being moved by player)
var is_active : bool = false
#if a puyo is meant to be resting:
var is_resting : bool = false

@onready var position_goal : Vector2 = position

#sprite sizing vars
@export var sprite_size : int = 50
@export var size_scale : float = 1.0

@export var move_speed : float = 10
var move_flag : bool = false

func _ready():
	##FOR TESTING
	#create_puyo(4, false)
	pass
	
func _physics_process(delta: float) -> void:
	if position_goal != position and move_flag:
		position = position.lerp(position_goal, delta * move_speed)
	elif position_goal == position and move_flag == true:
		reached_bottom.emit()
		move_flag = false

#simple initializer for a new puyo 
func create_puyo(type: PUYO_TYPE, new_junk: bool):
	is_junk = new_junk
	
	set_type(type)

#sets the puyo's type
func set_type(type: PUYO_TYPE):
	$AnimatedSprite2D.frame = type
	puyo_type = type
	
#getter for puyo_type
func  get_type():
	return puyo_type

func set_pos(pos):
	position = pos
	$AnimatedSprite2D.position = Vector2.ZERO

#changes puyo to be junk (for later usage):
#we can create a fucntion specifically for setting junk to a specific TYPE if needed later
func set_junk():
	is_junk = true
	set_type(PUYO_TYPE.JUNK)
#junk status checker. returns a bool
func get_junk():
	return is_junk

#sets if puyo is the active one
func set_active(new_status: bool):
	is_active = new_status
#active status getter
func get_active():
	return is_active

#sets puyo to be resting (i can't currently think of a reason a puyo would stop resting
func rest():
	is_resting = true
#gets the status of if it is resting
func get_resting():
	return is_resting

func set_new_goal(new_position : Vector2):
	position_goal = new_position
	move_flag = true

#gets given how large each square in the grid will be and resizes the object
#accordingly. gets given size of grid in pixels, and changes scale
##TODO make sure this doesn't fuck up the art, ideally the art scale should be decided upon before this
func set_puyo_size(new_size : int):
	var new_scale : float = float(new_size) / float(sprite_size)
	size_scale = new_scale
	scale = Vector2(size_scale, size_scale)
#returns vector2
func get_puyo_size():
	return scale
	


func pop():
	#print("pop!")
	##TODO add signal to game manager when puyo game is in base state
	pass
