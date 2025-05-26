extends BaseRelic

func initialize() -> void:
	super()
	player.on_player_damage_taken.connect(return_damage)
	

func return_damage(damage_taken, attack_type) -> void:
	print("proc spikeskin")
	(get_node("/root/Combat") as CombatManager).damage_all_enemies(5) 
	update_enemy_damage_visuals.emit()
