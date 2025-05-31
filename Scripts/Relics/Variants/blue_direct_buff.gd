extends BaseRelic

##whenever you pop a blue block, increase your minimum shield by 1

signal add_blue_buff(amount : int)

@export var shield_increase_amount : int = 1

func initialize():
	super()
	puyo_manager.player_attack.connect(blue_pop)
	add_blue_buff.connect(player.add_minimum_shield)
	print("blue_pop connected: %s" % puyo_manager.player_attack.is_connected(blue_pop))

func blue_pop(attack : PlayerAttack):
	if attack.type == Puyo.PUYO_TYPE.BLUE:
		var modifier = int((EncounterTrackerForRelics.get_count() - 1) / 2)
		sound_manager.relic_ding_play()
		add_blue_buff.emit(shield_increase_amount + modifier)
		combat_effects.create_relic_effect(self.global_position, combat_effects.shield_location_marker, AttackEffectData.EFFECT_TYPE.PLAYER_BLUE, false)
