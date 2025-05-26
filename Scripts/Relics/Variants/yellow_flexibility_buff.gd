extends BaseRelic

signal change_damage_calculation_from_yellow_relic

func initialize() -> void:
	super()
	change_damage_calculation_from_yellow_relic.connect(player.gain_yellow_shield_relic_buff)
	change_damage_calculation_from_yellow_relic.emit()
