extends Node2D

class_name MapNode

enum MAP_NODE_TYPE {BATTLE, BOSS_BATTLE, SENSATION_REWARD, PUYO_POOL_CHANGE, HEAL}
var map_node_type : MAP_NODE_TYPE

func initialize(new_type : MAP_NODE_TYPE):
	map_node_type = new_type
