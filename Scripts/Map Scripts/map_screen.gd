extends CanvasLayer

class_name MapScreen

signal option_chosen(option : int)

@export var option_buttons : Array[Button]

func _on_map_option_1_pressed() -> void:
	option_chosen.emit(0)

func _on_map_option_2_pressed() -> void:
	option_chosen.emit(1)

func _on_map_option_3_pressed() -> void:
	option_chosen.emit(2)

func _on_boss_option_button_pressed() -> void:
	pass # Replace with function body.

func generate_options(new_options : Array[MapNodeSegmentData], goal_icon : MapNode.MAP_NODE_TYPE):
	option_buttons[0].get_children()[0].create_node_sprites(new_options[0])
	for i in range(0,3):
		#option_buttons[i].text = new_options[i].segment_name
		option_buttons[i].get_children()[0].create_node_sprites(new_options[i])
	
	match goal_icon:
		MapNode.MAP_NODE_TYPE.BOSS_BATTLE:
			$NormalOptions/GoalIcon.texture = load("res://Placeholder Art/map_node_images/boss_location.png")
		MapNode.MAP_NODE_TYPE.SENSATION_REWARD:
			$NormalOptions/GoalIcon.texture = load("res://Placeholder Art/map_node_images/relic_location.png")
		MapNode.MAP_NODE_TYPE.PUYO_POOL_CHANGE:
			$NormalOptions/GoalIcon.texture = load("res://Placeholder Art/map_node_images/swap_location.png")
		
