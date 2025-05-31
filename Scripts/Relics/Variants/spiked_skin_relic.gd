extends BaseRelic

func initialize() -> void:
	super()
	player.on_player_damage_taken.connect(return_damage)
	

func return_damage(damage_taken, attack_type) -> void:
	print("proc spikeskin")
	sound_manager.relic_ding_play()
	(get_node("/root/Combat") as CombatManager).damage_all_enemies(5) 
	for enemy : Enemy in combat_manager.enemies:
		combat_effects.create_relic_effect(self.global_position, enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN)
