extends BaseRelic
#whenever a junk pops, deals x damage to all enemies.

@export var junk_damage : int = 1

signal deal_junk_damage(damage:int)

func initialize():
	super()
	puyo_manager.on_junk_popped.connect(junk_pop)
	deal_junk_damage.connect(combat_manager.damage_all_enemies)
	print("junk 2 damage connected: %s" % puyo_manager.on_junk_popped.is_connected(junk_pop))

func junk_pop(junk_amount : int):
	if junk_amount > 0:
		deal_junk_damage.emit(junk_damage * junk_amount)
		##replace with effect
		sound_manager.relic_ding_play()
		for enemy : Enemy in combat_manager.enemies:
			combat_effects.create_relic_effect(self.global_position, enemy.global_position, AttackEffectData.EFFECT_TYPE.JUNK)
