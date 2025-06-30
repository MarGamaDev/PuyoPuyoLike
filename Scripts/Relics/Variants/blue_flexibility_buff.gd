extends BaseRelic

#whenever an attack is fully blocked by shield, deal half of your shield as damage
#to selected attacker

signal deal_shield_damage(damage : int)

func initialize():
	super()
	player.on_attack_blocked.connect(on_attack_blocked)
	deal_shield_damage.connect(combat_manager.damage_targeted_enemy)

func on_attack_blocked(damage_blocked : int, shield_before_damage : int):
	if damage_blocked <= shield_before_damage:
		#print("blue flexibility buff triggered")
		deal_shield_damage.emit(int(0.5 * shield_before_damage))
		combat_effects.create_relic_effect(self.global_position, combat_manager.selected_enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_BLUE)
		sound_manager.relic_ding_play()
		#update_enemy_damage_visuals.emit()
	##print("damage blocked %s" % damage_blocked)
	##print("shield before %s " % shield_before_damage)
	pass
