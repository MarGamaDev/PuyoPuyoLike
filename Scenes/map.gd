extends Control

@onready var map_node_scene = load("res://Scenes/map_node.tscn")

var location_nodes : Array[MapNode] #doesn't contain current node
var journey_length : int = 0 # how far the player has traveled through the map
var current_node : MapNode

func _ready():
	create_map()
	pass

func create_map():
	var map_node_1 : MapNode = map_node_scene.instantiate()
	map_node_1.create(MapNode.LOCATION_TYPES.ENEMY)
	$CurrentLocationMarker.add_child(map_node_1)
	current_node = map_node_1
	initialize_location_queue()

func initialize_location_queue():
	while (location_nodes.size() < 3):
		var new_node: MapNode = map_node_scene.instantiate()
		new_node.create(randi_range(0,2))
		location_nodes.append(new_node)
	$NextLocationMarker1.add_child(location_nodes[0])
	$NextLocationMarker2.add_child(location_nodes[1])
	$NextLocationMarker3.add_child(location_nodes[2])
	pass
