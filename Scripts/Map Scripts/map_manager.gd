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
var map_options : Array[MapNodeSegmentData] = []
var next_segment : int = 0

var current_segment_selected_from_map_flag : bool = false

var pause_flag = false
var reward_flag = false
var swap_flag = false
var heal_flag = false

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
		generate_map_options()
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
				#pause_flag = false
				if first_battle_flag:
					pause_flag = false
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
				pause_flag = true
				reward_flag = true
				#print("open reward menu")
				#print(current_segment.map_segment_data.segment_name)
			MapNode.MAP_NODE_TYPE.PUYO_POOL_CHANGE:
				pause_flag = true
				swap_flag = true
				#print(current_segment.map_segment_data.segment_name)
			MapNode.MAP_NODE_TYPE.HEAL:
				pause_flag = true
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
					pause_flag = true
			_:
				print("map type error")

func generate_next_segment():
	var next_segment_data : MapNodeSegmentData
	if first_battle_flag:
		current_segment.initialize_segment_from_data(load("res://Resources/Map Segments/first_segment.tres"))
	else:
		if current_segment_selected_from_map_flag:
			current_segment_selected_from_map_flag = false
			next_segment_data = map_options[next_segment]
		else:
			next_segment_data = load(segment_folder_path + segment_paths[randi_range(0, segment_paths.size() - 1)])
		current_segment.initialize_segment_from_data(next_segment_data)
	end_combat.emit()
	combat_start_flag = true
	pass

func _on_reward_chosen_or_skipped():
	print("reward chosen or skipped")
	generate_next_segment()
	start_combat.emit()

func generate_map_options():
	map_options = []
	for i in range(0, 3):
		var new_option = load(segment_folder_path + segment_paths[randi_range(0, segment_paths.size() - 1)])
		while (map_options.has(new_option)):
			new_option = load(segment_folder_path + segment_paths[randi_range(0, segment_paths.size() - 1)])
		map_options.append(new_option)
	map_screen.generate_options(map_options)
	pass


func _on_map_screen_option_chosen(option: int) -> void:
	current_segment_selected_from_map_flag = true
	next_segment = option
	map_screen.hide()
	generate_next_segment()
	start_combat.emit()
	pass # Replace with function body.

func on_wave_complete():
	if pause_flag:
		if reward_flag:
			reward_flag = false
			open_reward_menu.emit()
		if swap_flag:
			swap_flag = false
			open_deckuilding_menu.emit()
		if map_open_flag:
			map_open_flag = false
			generate_map_options()
			end_combat.emit()
			map_screen_open.emit()
			map_screen.show()
		if heal_flag:
			heal_flag = false
			open_deckuilding_menu.emit()
	else:
		_on_attempt_to_move_to_next_node()
	
