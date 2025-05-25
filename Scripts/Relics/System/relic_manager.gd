class_name RelicManager extends Node

signal all_clear_for_next_encounter

func add_relic(relic_data: RelicData) -> void:
	var new_relic = await load(relic_data.file_path).instantiate()
	add_child(new_relic)
	#new_relic.reparent(self)
	new_relic.initialize()
	add_relic_visual(relic_data.sprite)
	new_relic.update_enemy_damage_visuals.connect(update_enemy_visual_damage_queue)
	all_clear_for_next_encounter.emit()
	pass

func add_relic_visual(sprite: Texture) -> void:
	var new_visual = TextureRect.new()
	new_visual.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	new_visual.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	new_visual.texture = sprite
	$CanvasLayer/RelicContainer.add_child(new_visual)
	pass

#may not need this later
func update_enemy_visual_damage_queue():
	var combat_manager : CombatManager = get_node("/root/Combat")
	for enemy : Enemy in combat_manager.enemies:
		enemy.update_damage_visually()
	
