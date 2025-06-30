extends BaseRelic

signal deal_aoe_damage

func initialize():
	super()
	deal_aoe_damage.connect(combat_manager.damage_all_enemies)
	puyo_manager.player_attack.connect(green_pop)
	#print("test_relic_connected: %s" % puyo_manager.player_attack.is_connected(green_pop))

func green_pop(attack: PlayerAttack) -> void:
		var enemy_count = encounter_manager.current_encounter.enemy_count
		deal_aoe_damage.emit(1000)
		sound_manager.relic_ding_play()
		for enemy : Enemy in combat_manager.enemies:
			combat_effects.create_relic_effect(self.global_position, enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN)
