extends Node2D

class_name MapSegment

var map_nodes : Array[MapNode] = []
var map_segment_data : MapNodeSegmentData
var segment_counter : int = 0

var map_node_scene : PackedScene = preload("res://Scenes/Map/map_node.tscn")

func _ready() -> void:
	pass

func initialize_segment_from_data(new_data : MapNodeSegmentData):
	map_segment_data = null
	map_nodes = []
	segment_counter = 0
	
	map_segment_data = new_data
	for node_type : MapNode.MAP_NODE_TYPE in map_segment_data.map_nodes:
		var new_map_node = map_node_scene.instantiate()
		add_child(new_map_node)
		new_map_node.initialize(node_type)
		map_nodes.append(new_map_node)

func get_next_encounter_type() -> MapNode.MAP_NODE_TYPE:
	if segment_counter >= map_nodes.size():
		##TODO change
		#print("advance, segment counter: %s" % segment_counter)
		return MapNode.MAP_NODE_TYPE.ADVANCE_NODE
	else:
		var node_type_to_return = map_nodes[segment_counter].map_node_type
		segment_counter += 1
		#\print("segment counter: %s" % segment_counter)
		return node_type_to_return

func reset_nodes():
	for i in map_nodes:
		i.queue_free()
