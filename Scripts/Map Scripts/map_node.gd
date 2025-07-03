extends Node2D

class_name MapNode

enum MAP_NODE_TYPE {BATTLE, BOSS_BATTLE, SENSATION_REWARD, PUYO_POOL_CHANGE, HEAL, ADVANCE_NODE}
var map_node_type : MAP_NODE_TYPE

#@onready var map_node_sprite : AnimatedSprite2D = $MapNodeSprite

func initialize(new_type : MAP_NODE_TYPE):
	map_node_type = new_type
	#match  map_node_type:
		#MAP_NODE_TYPE.BATTLE:
			#map_node_sprite.frame = 0
		#MAP_NODE_TYPE.BOSS_BATTLE:
			#map_node_sprite.frame = 1
		#MAP_NODE_TYPE.SENSATION_REWARD:
			#map_node_sprite.frame = 2
		#MAP_NODE_TYPE.PUYO_POOL_CHANGE:
			#map_node_sprite.frame = 3
