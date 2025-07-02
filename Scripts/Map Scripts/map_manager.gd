extends Node2D

class_name MapManager

signal load_next_encounter(boss_flag : bool)
signal load_first_battle(boss_flag : bool)

var current_segment : MapSegment
var map_segments : Array[MapSegment]

var first_battle_flag : bool = true

@export var test_segment : MapNodeSegmentData

##working on adding way to load a random segment
var segment_folder_path : String = "res://Resources/Map Segments/Possible Segments/"
var segment_paths : PackedStringArray

func _ready() -> void:
	segment_paths = ResourceLoader.list_directory(segment_folder_path)
	
	var map_segments = get_children()
	current_segment = map_segments[0]
	current_segment.initialize_segment_from_data(load("res://Resources/Map Segments/first_battle.tres"))

func _on_attempt_to_move_to_next_node():
	var next_node_type : MapNode.MAP_NODE_TYPE = current_segment.get_next_encounter_type()
	match next_node_type:
		MapNode.MAP_NODE_TYPE.BOSS_BATTLE:
			load_next_encounter.emit(true)
			print(current_segment.map_segment_data.segment_name)
		MapNode.MAP_NODE_TYPE.BATTLE:
			if first_battle_flag:
				load_first_battle.emit(false)
				first_battle_flag = false
				#print("first battle started")
			else:
				load_next_encounter.emit(false)
				print("moved to next battle")
			print(current_segment.map_segment_data.segment_name)
		MapNode.MAP_NODE_TYPE.SENSATION_REWARD:
			print("give reward")
			print(current_segment.map_segment_data.segment_name)
		MapNode.MAP_NODE_TYPE.PUYO_POOL_CHANGE:
			print("give puyo_change")
			print(current_segment.map_segment_data.segment_name)
		MapNode.MAP_NODE_TYPE.HEAL:
			print("gain life")
			print(current_segment.map_segment_data.segment_name)
		MapNode.MAP_NODE_TYPE.ADVANCE_NODE:
			print("move to next node")
			generate_next_segment()
		_:
			print("map type error")

func generate_next_segment():
	var next_segment_data : MapNodeSegmentData
	next_segment_data = load(segment_folder_path + segment_paths[randi_range(0, segment_paths.size() - 1)])
	current_segment.initialize_segment_from_data(next_segment_data)
	_on_attempt_to_move_to_next_node()
	pass
