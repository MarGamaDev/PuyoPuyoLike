extends BaseRelic
#whenever a green block is popped, deal extra damage to each enemy per each enemy hit
@export var extra_damage_per_enemy :int = 1

signal deal_aoe_damage

func initialize():
	super()
	deal_aoe_damage.connect(combat_manager.damage_all_enemies)
	puyo_manager.player_attack.connect(green_pop)
	print("green_buff connected: %s" % puyo_manager.player_attack.is_connected(green_pop))

func green_pop(attack: PlayerAttack) -> void:
	var enemy_count = encounter_manager.current_encounter.enemy_count
	deal_aoe_damage.emit(extra_damage_per_enemy * enemy_count * puyo_values.green_chain_multiplier * attack.chain)
	update_enemy_damage_visuals.emit()
