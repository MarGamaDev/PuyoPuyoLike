class_name AfterBurner extends BaseRelic

func initialize() -> void:
	super()
	puyo_manager.player_attack.connect(enhance_red_damage)
	print("afterburner connected: %s" % puyo_manager.player_attack.is_connected(enhance_red_damage))


func enhance_red_damage(attack: PlayerAttack) -> void:
	if attack.type == Puyo.PUYO_TYPE.RED:
		print("proc afterburner")
		(get_node("/root/Combat") as CombatManager).damage_targeted_enemy(3)
		update_enemy_damage_visuals.emit()
