class_name AfterBurner extends BaseRelic

func initialize() -> void:
	super()
	var puyo_manager : PuyoManager = get_node("/root/Combat/PuyoManager")
	puyo_manager.player_attack.connect(enhance_red_damage)

func enhance_red_damage(attack: PlayerAttack) -> void:
	if attack.type == Puyo.PUYO_TYPE.RED:
		(get_node("/root/Combat") as CombatManager).damage_targeted_enemy(3)
