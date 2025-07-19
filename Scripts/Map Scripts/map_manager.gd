extends Node2D

class_name MapManager

signal load_next_encounter(boss_flag : bool)
signal load_first_battle(boss_flag : bool)
signal open_reward_menu()
signal open_deckuilding_menu()
signal map_screen_open()
signal end_combat()
signal start_combat()
signal increase_difficulty_level()

signal hide_combat()
signal show_combat()

signal final_boss_fight_started()

var current_segment : MapSegment
var map_segments : Array[MapSegment]

var first_battle_flag : bool = true

@export var test_segment : MapNodeSegmentData

##working on adding way to load a random segment
var segment_folder_path : String = "res://Resources/Map Segments/Possible Segments/"
var segment_paths : PackedStringArray

var combat_start_flag : bool = false

@onready var map_screen : MapScreen = $MapScreen
var map_open_flag : bool = false
var map_options : Array[MapNodeSegmentData] = []
var next_segment : int = 0
var map_finished_picking_flag = false

var current_segment_selected_from_map_flag : bool = false

var node_queue : Array[MapNode.MAP_NODE_TYPE] = []

@export var segments_between_boss_fights : int = 2
var boss_fight_interval_counter = 0
var boss_fight_counter = 0
@export var difficulty_thresholds : Array[int] = [2, 3]
var endless_flag = false

var goal_type : MapNode.MAP_NODE_TYPE = MapNode.MAP_NODE_TYPE.PUYO_POOL_CHANGE
var end_of_segment_flag : bool = false

@onready var boss_segment : MapNodeSegmentData = preload("res://Resources/Map Segments/Goal Segments/boss_segment.tres")

@export var bosses_to_beat_for_win : int = 6

func _ready() -> void:
	segment_paths = ResourceLoader.list_directory(segment_folder_path)
	
	map_screen.hide()
	
	boss_fight_counter = 0
	
	var map_segments = get_children()
	current_segment = map_segments[0]
	current_segment.initialize_segment_from_data(load("res://Resources/Map Segments/first_segment.tres"))

func _on_attempt_to_move_to_next_node():
	hide_combat.emit()
	if first_battle_flag:
		show_combat.emit()
		first_battle_flag = false
		load_first_battle.emit(false)
		node_queue = [MapNode.MAP_NODE_TYPE.ADVANCE_NODE]
	else:
		var next_node_type : MapNode.MAP_NODE_TYPE = node_queue.pop_front()
		match next_node_type:
			MapNode.MAP_NODE_TYPE.BOSS_BATTLE:
				load_next_encounter.emit(true)
				show_combat.emit()
				if combat_start_flag:
					combat_start_flag = false
					start_combat.emit()
				boss_fight_counter += 1
				if boss_fight_counter == bosses_to_beat_for_win:
					final_boss_fight_started.emit()
				if endless_flag == false:
					if boss_fight_counter >= difficulty_thresholds[0]:
						increase_difficulty_level.emit()
						difficulty_thresholds.pop_front()
					if difficulty_thresholds.is_empty():
						endless_flag = true
			MapNode.MAP_NODE_TYPE.BATTLE:
				show_combat.emit()
				#pause_flag = false
				if first_battle_flag:
					load_first_battle.emit(false)
				else:
					load_next_encounter.emit(false)
				if combat_start_flag:
					combat_start_flag = false
					start_combat.emit()
			MapNode.MAP_NODE_TYPE.SENSATION_REWARD:
				open_reward_menu.emit()
			MapNode.MAP_NODE_TYPE.PUYO_POOL_CHANGE:
				open_deckuilding_menu.emit()
			MapNode.MAP_NODE_TYPE.HEAL:
				print("gain life")
				##CHANGE
				open_deckuilding_menu.emit()
			MapNode.MAP_NODE_TYPE.ADVANCE_NODE:
				if end_of_segment_flag:
					end_of_segment_flag = false
					match goal_type:
						MapNode.MAP_NODE_TYPE.BOSS_BATTLE:
							node_queue.append(MapNode.MAP_NODE_TYPE.BOSS_BATTLE)
							node_queue.append(MapNode.MAP_NODE_TYPE.HEAL)
							node_queue.append(MapNode.MAP_NODE_TYPE.SENSATION_REWARD)
							node_queue.append(MapNode.MAP_NODE_TYPE.PUYO_POOL_CHANGE)
						MapNode.MAP_NODE_TYPE.SENSATION_REWARD:
							node_queue.append(MapNode.MAP_NODE_TYPE.SENSATION_REWARD)
						MapNode.MAP_NODE_TYPE.PUYO_POOL_CHANGE:
							node_queue.append(MapNode.MAP_NODE_TYPE.PUYO_POOL_CHANGE)
					node_queue.append(MapNode.MAP_NODE_TYPE.ADVANCE_NODE)
					_on_attempt_to_move_to_next_node()
				else:
					DifficultyManager.increase_scaling_flat()
					open_map_screen()
			_:
				print("map type error")

func generate_next_segment(map_flag := false):
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
	var segment_finished_loop_flag = false
	while segment_finished_loop_flag == false:
		node_queue.append(current_segment.get_next_encounter_type())
		var node_check = node_queue.pop_back()
		if node_check == MapNode.MAP_NODE_TYPE.ADVANCE_NODE:
			segment_finished_loop_flag = true
		node_queue.append(node_check)
	combat_start_flag = true
	if map_finished_picking_flag:
		map_finished_picking_flag = false
		current_segment.reset_nodes()
		_on_attempt_to_move_to_next_node()

func _on_reward_chosen_or_skipped():
	combat_start_flag = true
	hide_combat.emit()
	_on_attempt_to_move_to_next_node()
	#start_combat.emit()

func generate_map_options():
	hide_combat.emit()
	map_options = []
	end_of_segment_flag = true
	boss_fight_interval_counter += 1
	if boss_fight_interval_counter >= segments_between_boss_fights:
		goal_type = MapNode.MAP_NODE_TYPE.BOSS_BATTLE
	else:
		if randi_range(0,1) == 0:
			goal_type = MapNode.MAP_NODE_TYPE.SENSATION_REWARD
		else:
			goal_type = MapNode.MAP_NODE_TYPE.PUYO_POOL_CHANGE
	for i in range(0, 3):
		var new_option = load(segment_folder_path + segment_paths[randi_range(0, segment_paths.size() - 1)])
		while (map_options.has(new_option)):
			new_option = load(segment_folder_path + segment_paths[randi_range(0, segment_paths.size() - 1)])
		map_options.append(new_option)
	map_screen.generate_options(map_options, goal_type)
	pass

func open_map_screen():
	hide_combat.emit()
	generate_map_options()
	end_combat.emit()
	map_screen_open.emit()
	map_screen.show()

func _on_map_screen_option_chosen(option: int) -> void:
	current_segment_selected_from_map_flag = true
	map_finished_picking_flag = true
	map_open_flag = false
	next_segment = option
	map_screen.hide()
	generate_next_segment()
	#start_combat.emit()
	pass # Replace with function body.

func on_wave_complete():
	hide_combat.emit()
	if map_open_flag:
		open_map_screen()
	else:
		_on_attempt_to_move_to_next_node()
