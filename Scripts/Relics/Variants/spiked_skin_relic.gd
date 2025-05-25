extends BaseRelic

func initialize() -> void:
	super()
	get_node("root/Combat/Player").connect("on_life_lost", return_damage)

func return_damage() -> void:
	(get_node("/root/Combat") as CombatManager).damage_all_enemies(3) 
	pass
