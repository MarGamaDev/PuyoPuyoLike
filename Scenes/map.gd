extends Control

@onready var map_node_scene = load("res://Scenes/map_node.tscn")

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
	construct_map()

func construct_map():
	pass
