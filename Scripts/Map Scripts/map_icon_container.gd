extends VBoxContainer

class_name MapIconContainer

func create_node_sprites(map_data : MapNodeSegmentData):
	for i in get_children():
		i.queue_free()
	var map_nodes : Array[MapNode.MAP_NODE_TYPE] = map_data.map_nodes
	var required_sprite_count = map_nodes.size() + (map_nodes.size() - 1)
	var sprite_counter = 0
	var contained_nodes = []
	for node_sprite in range(0, required_sprite_count):
		var map_sprite : TextureRect = TextureRect.new()
		map_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		if node_sprite != sprite_counter * 2:
			map_sprite.texture = load("res://Placeholder Art/map_node_images/arrow.png")
		else:
			match map_nodes[sprite_counter]:
				MapNode.MAP_NODE_TYPE.BATTLE:
					map_sprite.texture = load("res://Placeholder Art/map_node_images/enemy_location.png")
				MapNode.MAP_NODE_TYPE.BOSS_BATTLE:
					map_sprite.texture = load("res://Placeholder Art/map_node_images/boss_location.png")
				MapNode.MAP_NODE_TYPE.SENSATION_REWARD:
					map_sprite.texture = load("res://Placeholder Art/map_node_images/relic_location.png")
				MapNode.MAP_NODE_TYPE.PUYO_POOL_CHANGE:
					map_sprite.texture = load("res://Placeholder Art/map_node_images/swap_location.png")
			sprite_counter += 1
		contained_nodes.append(map_sprite)
	var array_size = contained_nodes.size()
	for j in range(0,array_size):
		add_child(contained_nodes.pop_back())
	pass
