extends Node2D

class_name MapManager

signal load_next_encounter(boss_flag : bool)
signal load_first_battle(boss_flag : bool)

var current_segment : MapSegment
var map_segments : Array[MapSegment]

var first_battle_flag : bool = true

@export var test_segment : MapNodeSegmentData

func _ready() -> void:
	var map_segments = get_children()
	current_segment = map_segments[0]
	current_segment.initialize_segment_from_data(load("res://Resources/Map Segments/first_battle.tres"))
	current_segment.initialize_segment_from_data(test_segment)

func _on_attempt_to_move_to_next_node():
	var next_node_type : MapNode.MAP_NODE_TYPE = current_segment.get_next_encounter_type()
	match next_node_type:
		MapNode.MAP_NODE_TYPE.BOSS_BATTLE:
			load_next_encounter.emit(true)
		MapNode.MAP_NODE_TYPE.BATTLE:
			if first_battle_flag:
				load_first_battle.emit(false)
				first_battle_flag = false
				print("first battle started")
			else:
				load_next_encounter.emit(false)
				print("moved to next battle")
		MapNode.MAP_NODE_TYPE.SENSATION_REWARD:
			print("give reward")
		MapNode.MAP_NODE_TYPE.PUYO_POOL_CHANGE:
			print("give puyo_change")
		MapNode.MAP_NODE_TYPE.HEAL:
			print("gain a life")
