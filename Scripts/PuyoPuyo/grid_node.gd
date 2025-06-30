extends Node2D

class_name GridNode

##notes:
##the puyo sprites should be uncentered (pivot at top left)? i think that makes
##things a lot easier.

#the puyo that this node should be holding. export is for testing
@export var puyo : Puyo = null
#TODO maybe remove? adding just bc it may be easier
var is_holding_puyo : bool = false
#how wide the grid is meant to be (in pixels, currently 50)
#TODO maybe this could be a global variable, idk
var node_size : int = 50
#array of neighbouring nodes. set by gridmanager when created
var neighbours : Array[GridNode] = []
#tracker for when we're checking the board to remove blocks
var is_checked : bool = false
#if the node is part of the off-field grid, true if it is out of the play field
var is_out_of_play : bool = false



var grid_index : Vector2i

var x: int:
	get:
		return grid_index.x
		
var y: int:
	get:
		return grid_index.y

func _ready():
	#for testing
	#puyo.create_puyo(2, true)
	##print(puyo.is_junk)
	pass


#adding a puyo to the node, takes a puyo
func set_puyo(new_puyo : Puyo):
	puyo = new_puyo
	puyo.set_pos(position)
	is_holding_puyo = true

func move_puyo(new_puyo : Puyo):
	puyo = new_puyo
	puyo.set_new_goal(position)
	is_holding_puyo = true


#i was stupid and realised you can access class variables with .variable 
#color, junk, active, resting, size
func set_type(new_type : Puyo.PUYO_TYPE):
	if puyo != null:
		puyo.set_type(new_type)
func get_type():
	if puyo != null:
		return puyo.get_type()
	return null;

func set_junk():
	if puyo != null:
		puyo.set_junk()
func get_junk():
	if puyo != null:
		return puyo.get_junk()

func set_active(new_active : bool):
	if puyo != null:
		puyo.set_active(new_active)
func get_active():
	if puyo != null:
		return puyo.get_active()

func rest():
	if puyo != null:
		puyo.rest()
func get_resting():
	if puyo != null:
		return puyo.get_resting()

func set_puyo_size(new_size : int):
	if puyo != null:
		puyo.set_puyo_size(new_size)
func get_puyo_size():
	if puyo != null:
		return puyo.get_puyo_size()

func set_test_sprite(test : bool):
	$OOBTest.visible = test

#resets node (not neighbours or out of bounds)
func reset():
	puyo = null
	is_holding_puyo  = false
	is_checked = false
