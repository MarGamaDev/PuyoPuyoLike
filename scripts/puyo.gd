extends Node2D

class_name Puyo

##colors are junk: 0, blue : 1, green : 2, red : 3, yellow : 4
var color : int = 1
#junk status (i.e. is a junk or not)
var is_junk : bool = false
#if a puyo is part of an 'active' pair (being moved by player)
var is_active : bool = false
#if a puyo is meant to be resting:
var is_resting : bool = false

#sprite sizing vars
@export var sprite_size : int = 50
@export var size_scale : float = 1.0

func _ready():
	##FOR TESTING
	#create_puyo(4, false)
	pass

#simple initializer for a new puyo 
func create_puyo(new_color: int, new_junk: bool):
	#setting values
	color = new_color
	is_junk = new_junk
	#setting correctly color
	set_color(color)

#sets the puyo's color
func set_color(new_color: int):
	$AnimatedSprite2D.frame = new_color
	color = new_color
	
#getter for color. returns an int
func  get_color():
	return color

#changes puyo to be junk (for later usage):
#we can create a fucntion specifically for setting junk to a specific color if needed later
func set_junk():
	is_junk = true
	set_color(0)
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
