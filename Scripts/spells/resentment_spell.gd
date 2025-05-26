extends SequentialSpell

#deals a damage blast to every enemy
@export var spell_damage = 40

signal deal_spell_damage(damage : int)

func connect_to_effect_signals():
	deal_spell_damage.connect(combat_manager.damage_all_enemies)

func trigger_spell_effect():
	print("Resentment cast")
	deal_spell_damage.emit(spell_damage)
	for i in combat_manager.enemies:
		combat_effects.create_spell_effect(container_location_marker.global_position, i.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_RED)
