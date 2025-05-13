class_name PuyoQueueEvent extends RefCounted

#row = row of junk, random = x random junks, specific = get given a range
enum EVENT_TYPE {PLAYER, JUNKROW, JUNKRANDOM, JUNKSPECIFIC}
var event_type : EVENT_TYPE = EVENT_TYPE.PLAYER
var junk_rows : int = 0
var junk_random : int = 0
var junk_positions : Array[Vector2i] = []

static func create(type: EVENT_TYPE, rows: int = 0, random_amount: int = 0, specific_positions: Array[Vector2i] = []):
	var instance = PuyoQueueEvent.new()
	instance.event_type = type
	instance.junk_rows = rows
	instance.junk_random = random_amount
	instance.junk_positions = specific_positions
	return instance
