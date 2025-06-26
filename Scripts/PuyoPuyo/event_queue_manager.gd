extends Node2D

class_name EventQueueManager

signal event_create_player
signal event_create_junk_row(junk_number : int)
signal event_create_junk_specific(junk_positions : Array[Vector2i])
signal event_create_junk_random(junk_number:int)
signal event_replace_junk_specific(junk_positions : Array[Vector2i])
signal event_junk_slam(junk_number : int)
signal event_replace_color(color_to_change : Puyo.PUYO_TYPE, color_target : Puyo.PUYO_TYPE)
signal event_end_game
				
var event_queue : Array = []

var start_flag : bool = false

func reset_queue():
	event_queue = []

func process_queue() -> bool:
	var process_check = false
	if event_queue.size() == 0 and start_flag:
		event_queue.append(PuyoQueueEvent.create(PuyoQueueEvent.EVENT_TYPE.PLAYER))
	var next_event : PuyoQueueEvent = event_queue.pop_front()
	if next_event == null:
		pass
	elif next_event.event_type == PuyoQueueEvent.EVENT_TYPE.PLAYER:
		event_create_player.emit()
		#create_player_puyo()
	else:
		print("EVENT QUEUE TEST")
		process_check = true
		if next_event.event_type == PuyoQueueEvent.EVENT_TYPE.JUNK_ROW:
			event_create_junk_row.emit(next_event.junk_number)
			#create_junk_row(next_event.junk_number)
		elif next_event.event_type == PuyoQueueEvent.EVENT_TYPE.JUNK_SPECIFIC:
			event_create_junk_specific.emit(next_event.junk_positions)
			#create_junk_specific(next_event.junk_positions)
		elif next_event.event_type == PuyoQueueEvent.EVENT_TYPE.JUNK_RANDOM:
			event_create_junk_random.emit(next_event.junk_number)
			#create_junk_random(next_event.junk_number)
		elif next_event.event_type == PuyoQueueEvent.EVENT_TYPE.JUNK_REPLACE:
			event_replace_junk_specific.emit(next_event.junk_positions)
			#replace_junk_specific(next_event.junk_positions)
		elif next_event.event_type == PuyoQueueEvent.EVENT_TYPE.JUNK_SLAM:
			event_junk_slam.emit(next_event.junk_number)
			#junk_slam(next_event.junk_number)
		elif next_event.event_type == PuyoQueueEvent.EVENT_TYPE.COLOR_REPLACE:
			event_replace_color.emit(next_event.color_to_change, next_event.color_target)
			#replace_color(next_event.color_to_change, next_event.color_target)
		elif next_event.event_type == PuyoQueueEvent.EVENT_TYPE.END_GAME:
			event_end_game.emit()
			#down_tick()
			#await down_check_finished
			#end_game()
	return process_check

func add_event(new_event : PuyoQueueEvent):
	event_queue.append(new_event)
