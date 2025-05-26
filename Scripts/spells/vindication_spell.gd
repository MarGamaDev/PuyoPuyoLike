extends FlexibleSpell
#deals damage equal to chain * (counter + shield) at end of chain
signal deal_spell_damage(damage : int)

func connect_to_effect_signals():
	deal_spell_damage.connect(combat_manager.damage_targeted_enemy)
	

func trigger_spell_effect():
	puyo_manager.on_chain_ending.connect(reversal_attack)
	print(puyo_manager.on_chain_ending.is_connected(reversal_attack))

func reversal_attack(chain_mult : int):
	puyo_manager.on_chain_ending.disconnect(reversal_attack)
	var damage = chain_mult * (player.counter + player.shield)
	print("damage : %s" % damage)
	deal_spell_damage.emit(damage)
	combat_effects.create_spell_effect(container_location_marker.global_position, combat_manager.selected_enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_BLUE)
	#update_enemy_damage_visuals.emit()
