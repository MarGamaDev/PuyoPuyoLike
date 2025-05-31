class_name AfterBurner extends BaseRelic
##whenever you pop a red block, treat it as if it had 2 more puyos
@export var damage_enhancement :int = 2

func initialize() -> void:
	super()
	puyo_manager.player_attack.connect(enhance_red_damage)
	print("afterburner connected: %s" % puyo_manager.player_attack.is_connected(enhance_red_damage))


func enhance_red_damage(attack: PlayerAttack) -> void:
	if attack.type == Puyo.PUYO_TYPE.RED:
		print("proc afterburner")
		(get_node("/root/Combat") as CombatManager).damage_targeted_enemy(damage_enhancement * attack.chain * combat_manager.puyo_values.red_chain_multiplier)
		combat_effects.create_relic_effect(self.global_position, combat_manager.selected_enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_RED)
		sound_manager.relic_ding_play()
		#update_enemy_damage_visuals.emit()
