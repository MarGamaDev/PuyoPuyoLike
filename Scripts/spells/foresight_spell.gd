extends SequentialSpell

##deals current counter as damage to targeted enemy at end of the chain
signal deal_spell_damage(damage : int)

func connect_to_effect_signals():
	deal_spell_damage.connect(combat_manager.damage_targeted_enemy)

func trigger_spell_effect():
	puyo_manager.on_chain_ending.connect(counter_deal_damage)

func counter_deal_damage(chain_mult_unused: int):
	puyo_manager.on_chain_ending.disconnect(counter_deal_damage)
	var counter_damage = player.counter
	deal_spell_damage.emit(counter_damage)
	combat_effects.create_spell_effect(container_location_marker.global_position, combat_manager.selected_enemy.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_YELLOW)
	#print("foresight cast for %s" % counter_damage)
