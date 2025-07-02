extends Node2D

class_name MapManager

signal load_next_encounter(boss_flag : bool)
signal load_first_battle(boss_flag : bool)
signal open_reward_menu()
signal open_deckuilding_menu()
signal map_screen_open()
signal end_combat()
signal start_combat()

var current_segment : MapSegment
var map_segments : Array[MapSegment]

var first_battle_flag : bool = true
var first_battle_over_flag : bool = false

@export var test_segment : MapNodeSegmentData

##working on adding way to load a random segment
var segment_folder_path : String = "res://Resources/Map Segments/Possible Segments/"
var segment_paths : PackedStringArray

var combat_start_flag : bool = false

@onready var map_screen : MapScreen = $MapScreen
var map_open_flag : bool = false

func _ready() -> void:
	segment_paths = ResourceLoader.list_directory(segment_folder_path)
	
	map_screen.hide()
	
	var map_segments = get_children()
	current_segment = map_segments[0]
	current_segment.initialize_segment_from_data(load("res://Resources/Map Segments/first_segment.tres"))

func _on_attempt_to_move_to_next_node():
	if first_battle_flag:
		first_battle_flag = false
		first_battle_over_flag = true
		load_first_battle.emit(false)
		print("first battle started")
	elif map_open_flag:
		print("is this called")
		map_open_flag = false
		end_combat.emit()
		map_screen_open.emit()
		map_screen.show()
	else:
		var next_node_type : MapNode.MAP_NODE_TYPE = current_segment.get_next_encounter_type()
		match next_node_type:
			MapNode.MAP_NODE_TYPE.BOSS_BATTLE:
				load_next_encounter.emit(true)
				print(current_segment.map_segment_data.segment_name)
			MapNode.MAP_NODE_TYPE.BATTLE:
				if first_battle_flag:
					load_first_battle.emit(false)
					print("first battle started")
				else:
					load_next_encounter.emit(false)
					print("moved to next battle")
				if combat_start_flag:
					combat_start_flag = false
					#start_combat.emit()
				#print(current_segment.map_segment_data.segment_name)
			MapNode.MAP_NODE_TYPE.SENSATION_REWARD:
				#print("open reward menu")
				open_reward_menu.emit()
				#print(current_segment.map_segment_data.segment_name)
			MapNode.MAP_NODE_TYPE.PUYO_POOL_CHANGE:
				open_deckuilding_menu.emit()
				#print(current_segment.map_segment_data.segment_name)
			MapNode.MAP_NODE_TYPE.HEAL:
				print("gain life")
				open_deckuilding_menu.emit()
				#print(current_segment.map_segment_data.segment_name)
			MapNode.MAP_NODE_TYPE.ADVANCE_NODE:
				print("move to next segment")
				if first_battle_over_flag:
					map_open_flag = true
					first_battle_over_flag = false
					#print("is this called")
					generate_next_segment()
				else:
					generate_next_segment()
					map_open_flag = true
			_:
				print("map type error")

func generate_next_segment():
	var next_segment_data : MapNodeSegmentData
	if first_battle_flag:
		current_segment.initialize_segment_from_data(load("res://Resources/Map Segments/first_segment.tres"))
	else:
		next_segment_data = load(segment_folder_path + segment_paths[randi_range(0, segment_paths.size() - 1)])
		current_segment.initialize_segment_from_data(next_segment_data)
	end_combat.emit()
	combat_start_flag = true
	_on_attempt_to_move_to_next_node()
	pass

func _on_reward_chosen_or_skipped():
	print("reward chosen or skipped")
	start_combat.emit()


func _on_map_screen_option_chosen(option: int) -> void:
	map_screen.hide()
	generate_next_segment()
	start_combat.emit()
	pass # Replace with function body.
