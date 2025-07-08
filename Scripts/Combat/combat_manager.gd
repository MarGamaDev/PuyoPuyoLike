class_name CombatManager
extends Node2D

#signals after processing player attack
signal on_targeted_damage_dealt(int)
signal on_aoe_damage_dealt(int)
signal on_shield_gained(int)
signal on_counter_gained(int)
signal on_junk_cleared(int)

signal on_combat_started()
signal on_player_turn_taken()
signal on_enemy_attack(attack: EnemyAttack, enemy: Enemy)
signal on_enemy_registered(enemy: Enemy)
signal on_enemy_deregistered(enemy: Enemy)
signal on_player_life_lost()
signal on_encounter_finished()
signal on_delay_enemy_attack(delay_turns : int)
signal on_game_paused()
signal first_battle_started()

@export var puyo_values: PuyoValueData
@export var debug_mode : bool = false

var enemies: Array = Array()
var selected_enemy: Enemy

var current_encounter : Encounter

var first_battle_flag : bool = true

func _ready() -> void:
	if debug_mode:
		puyo_values.green_base_value = 100
		puyo_values.red_base_value = 100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(0.5))
	start_combat()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("switch_target") && selected_enemy:
		var index = enemies.find(selected_enemy) + 1
		index %= enemies.size()
		select_enemy(index);
	
	if Input.is_action_just_pressed("toggle_pause"):
		on_game_paused.emit()
		get_tree().paused = true

func process_player_attack(attack : PlayerAttack) -> void:
	var value: int = puyo_values.get_base_value(attack.type) * attack.size
	var mult: int = puyo_values.get_multiplier(attack.type) * attack.chain
	match attack.type:
		Puyo.PUYO_TYPE.GREEN:
			on_aoe_damage_dealt.emit(value * mult)
		Puyo.PUYO_TYPE.RED:
			on_targeted_damage_dealt.emit(value * mult)
		Puyo.PUYO_TYPE.BLUE:
			on_shield_gained.emit(value * mult)
		Puyo.PUYO_TYPE.YELLOW:
			on_counter_gained.emit(value * mult)
		Puyo.PUYO_TYPE.JUNK:
			on_junk_cleared.emit(attack.size)
	##PLAY ATTACK AND DEFENSE SFX HERE

func end_player_turn() -> void:
	on_player_turn_taken.emit()

func process_enemy_attack(enemy_attack: EnemyAttack, enemy : Enemy) -> void:
	on_enemy_attack.emit(enemy_attack, enemy)

func register_enemy(enemy : Enemy) -> void:
	##print("enemy registered")
	on_enemy_registered.emit(enemy)
	enemies.push_back(enemy)
	enemy.connect("on_attacking_player", process_enemy_attack)
	enemy.play_entrance_animation()

func deregister_enemy(enemy : Enemy) -> void:
	##print("enemy deregistered")
	on_enemy_deregistered.emit(enemy)
	enemies.erase(enemy)
	enemy.set_as_selected(false)
	
	if enemies.size() > 0 && selected_enemy:
		select_enemy(0)
	
	if enemies.size() == 0:
		#print("encounter over")
		on_encounter_finished.emit()

func trigger_counter(counter_amount: int) -> void:
	on_targeted_damage_dealt.emit(counter_amount)

func lose_player_life() -> void:
	on_player_life_lost.emit()

func process_encounter_updated(_encounter: Encounter) -> void:
	select_enemy(0)

func start_combat() -> void:
	on_combat_started.emit()
	if  first_battle_flag:
		first_battle_flag = false
		first_battle_started.emit()
	#$SpellManager.add_spell($SpellManager.test_spell)
	#$SpellManager.add_spell($SpellManager.test_spell_2)
	#$SpellManager.add_spell($SpellManager.test_spell_3)

func select_enemy(enemy_index: int) -> void:
	if selected_enemy:
		selected_enemy.set_as_selected(false)
	if enemies[enemy_index] == null:
		enemies.remove_at(enemy_index)
		enemy_index -= 1
	selected_enemy = enemies[enemy_index]
	selected_enemy.set_as_selected(true)

func damage_targeted_enemy(damage: int) ->void:
	on_targeted_damage_dealt.emit(damage)

func damage_all_enemies(damage : int) -> void:
	on_aoe_damage_dealt.emit(damage)

func gain_shield(shield: int):
	on_shield_gained.emit(shield)

func gain_counter(counter : int):
	on_counter_gained.emit(counter)

func delay_enemies(delay_time : int):
	on_delay_enemy_attack.emit(delay_time)

func get_free_spaces() -> int:
	return $PuyoManager.get_free_spaces_left()

func get_grid_node_global_position(pos: Vector2i) -> Vector2:
	return $PuyoManager.get_global_grid_position(pos)
