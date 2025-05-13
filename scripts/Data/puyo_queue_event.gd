class_name PuyoQueueEvent extends RefCounted

#row = row of junk, random = x random junks, specific = get given a range
enum EVENT_TYPE {PLAYER, JUNK_ROW, JUNK_RANDOM, JUNK_SPECIFIC, JUNK_REPLACE, JUNK_SLAM, COLOR_REPLACE}
#slam is the replace bottom rows that contain a non-junk puyo
var event_type : EVENT_TYPE = EVENT_TYPE.PLAYER
#junk_number is used differently depenign on what type of junk event happens
#for junkrows, is number of rows, for junkrandom, is the number of puyos to spawn
var junk_number : int = 0
var junk_random : int = 0
var junk_positions : Array[Vector2i] = []
var color_to_change : Puyo.PUYO_TYPE = Puyo.PUYO_TYPE.UNDEFINED
var color_target : Puyo.PUYO_TYPE = Puyo.PUYO_TYPE.UNDEFINED

static func create(type: EVENT_TYPE, junk_num: int = 0, specific_positions: Array[Vector2i] = [], new_color_to_change := Puyo.PUYO_TYPE.UNDEFINED, new_color_target := Puyo.PUYO_TYPE.UNDEFINED):
	var instance = PuyoQueueEvent.new()
	instance.event_type = type
	instance.junk_number = junk_num
	instance.junk_positions = specific_positions
	instance.color_target = new_color_target
	instance.color_to_change = new_color_to_change
	return instance
