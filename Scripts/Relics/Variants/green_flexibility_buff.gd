extends BaseRelic

#deals extra damage with every green popped per enemy killed in combat, or if there
#are less than 3 enemies at the start, the buff starts at 2 - 2 enemies, 3 - 1 enemy
#affected by chain

var enemy_count :int = 0
var green_buff = 1

signal green_buff_attack(damage: int)

func initialize() -> void:
	super()
	encounter_manager.on_update_encounter.connect(update_green_buff_on_start)
	combat_manager.on_enemy_deregistered.connect(update_green_buff_on_enemy_death)
	puyo_manager.player_attack.connect(trigger_green_attack)
	#print(puyo_manager.player_attack.is_connected(trigger_green_attack))
	green_buff_attack.connect(combat_manager.damage_all_enemies)

func update_green_buff_on_start(encounter : Encounter):
	enemy_count = encounter.enemy_count
	if enemy_count > 2:
		green_buff = 1
	elif enemy_count == 2:
		green_buff = 2
	elif enemy_count == 1:
		green_buff = 3
	else:
		print("error")

func update_green_buff_on_enemy_death(unused_enemy : Enemy):
	var modifier = int((EncounterTrackerForRelics.get_count() - 1) / 3)
	enemy_count -= 1
	green_buff += (1 + modifier)
	#combat_effects.create_relic_effect(unused_enemy.global_position, self.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN)
	pass

func trigger_green_attack(attack : PlayerAttack):
	#print("green_buff_test")
	if attack.type == Puyo.PUYO_TYPE.GREEN:
		sound_manager.relic_ding_play()
		green_buff_attack.emit(green_buff * attack.chain)
		for enemy : Enemy in combat_manager.enemies:
			combat_effects.create_relic_effect(self.global_position, enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN)
		#print("green buff attack activated, buff = %s" % green_buff)
		pass
