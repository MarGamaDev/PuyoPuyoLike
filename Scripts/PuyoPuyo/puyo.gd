extends Node2D

class_name Puyo

signal reached_bottom
signal pop_trigger(popped_type : PUYO_TYPE)

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
	var anim_point = (0.2 * sprite_size)
	var anim = $DropAnimation.get_animation("Drop")
	var anim_track = anim.find_track("Pivot:position",Animation.TYPE_VALUE)
	anim.track_set_key_value(anim_track, 1, Vector2(0,anim_point))
	##FOR TESTING
	#create_puyo(4, false)
	pass
	
func _physics_process(delta: float) -> void:
	if position_goal.y <= position.y + 5 and move_flag == true:
		play_drop_animation()
		position = position_goal
		reached_bottom.emit()
		move_flag = false
	elif position_goal != position and move_flag:
		position = position.lerp(position_goal, delta * move_speed)

#simple initializer for a new puyo 
func create_puyo(type: PUYO_TYPE, new_junk: bool):
	is_junk = new_junk
	
	set_type(type)

#sets the puyo's type
func set_type(type: PUYO_TYPE):
	$Pivot/AnimatedSprite2D.frame = type
	puyo_type = type
	
#getter for puyo_type
func  get_type():
	return puyo_type

func set_pos(pos):
	position = pos
	$Pivot/AnimatedSprite2D.position = Vector2.ZERO

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
	

func play_drop_animation():
	$DropAnimation.play("Drop")
	pass

func trigger_pop_effect():
	pop_trigger.emit(puyo_type)

func pop():
	pop_trigger.emit(puyo_type)
	queue_free()

func play_blink():
	$BlinkAnimation.play("Blink")

func become_junk():
	$Pivot/AnimatedSprite2D.hide()
	$Pivot/junk_look.show()
	$TurntoJunk.play("become_junk")
	#print("test junk become")
	await get_tree().create_timer(0.2).timeout
	$Pivot/junk_look.hide()
	$Pivot/AnimatedSprite2D.show()
