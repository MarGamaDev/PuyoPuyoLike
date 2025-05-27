class_name RelicManager extends Node

signal all_clear_for_next_encounter

@export var test_relic : RelicData

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("TESTING_player_spawn"):
		test_add_relic()

func add_relic(relic_data: RelicData) -> void:
	var new_relic = await load(relic_data.file_path).instantiate()
	add_child(new_relic)
	#new_relic.reparent(self)
	new_relic.initialize()
	var relic_visual_rect = add_relic_visual(test_relic.sprite).get_global_rect()
	new_relic.update_enemy_damage_visuals.connect(update_enemy_visual_damage_queue)
	await get_tree().create_timer(0.1).timeout
	new_relic.global_position = relic_visual_rect.position + (relic_visual_rect.size)
	all_clear_for_next_encounter.emit()
	pass

func add_relic_visual(sprite: Texture) -> TextureRect:
	var new_visual = TextureRect.new()
	new_visual.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	new_visual.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	new_visual.texture = sprite
	$CanvasLayer/RelicContainer.add_child(new_visual)
	return new_visual
	pass

#may not need this later
func update_enemy_visual_damage_queue():
	var combat_manager : CombatManager = get_node("/root/Combat")
	for enemy : Enemy in combat_manager.enemies:
		enemy.update_damage_visually()
	

func test_add_relic():
	var new_relic = await load(test_relic.file_path).instantiate()
	add_child(new_relic)
	#new_relic.reparent(self)
	new_relic.initialize()
	var relic_visual_rect = add_relic_visual(test_relic.sprite).get_global_rect()
	new_relic.update_enemy_damage_visuals.connect(update_enemy_visual_damage_queue)
	await get_tree().create_timer(0.1).timeout
	new_relic.global_position = relic_visual_rect.position + (relic_visual_rect.size)
