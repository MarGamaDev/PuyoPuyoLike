class_name Player
extends Node2D

signal on_counter_gain(counter_gained: int)
signal on_shield_gain(shield_gained: int)
signal on_shield_lost(shield_lost: int)
signal on_counter_triggered(counter_amount: int)
signal on_player_attacked
signal on_player_damage_taken(damage_taken: int, attack_type: EnemyAttack.EnemyAttackType)
signal on_life_lost
signal on_life_gain
signal on_set_life_to(num : int)
signal on_player_death
signal on_shield_change(new_shield: int)
signal on_counter_change(new_counter: int)
signal on_attack_blocked(damage_blocked : int, shield_before_damage : int)

signal trigger_blocked_effect(enemy : Enemy)
signal trigger_countered_effect(enemy : Enemy)

@onready var combat_effects_manager : CombatEffectsManager = get_node("/root/Combat/CombatEffectsManager")

var lives : int = 3
var shield : int = 0
var counter : int = 0

var counter_buff : int = 1
var counter_relic_buff : int = 1
var yellow_shield_buff_flag = false

var minimum_shield : int = 0

func _ready():
	on_set_life_to.emit(lives)

func receive_attack(attack: EnemyAttack, enemy: Enemy) -> void:
	on_player_attacked.emit()
	var damage_taken = 0
	for i in range(attack.number_of_swings):
		damage_taken += handle_damage(attack.damage, enemy)
	#add shield = 0 if we want to have the shield reset between attacks
	#if damage_taken > 0: #resets counter if damage is taken
		#counter = 0
		#if we want counter to reset between attacks no matter what, just remove condition
	if damage_taken > 0 and enemy != null:
		combat_effects_manager.create_attack_effect(enemy.global_position, combat_effects_manager.junk_indicator_marker, AttackEffectData.EFFECT_TYPE.JUNK)
	on_player_damage_taken.emit(damage_taken, attack.attack_type)

func add_counter(counter_gained: int) -> void:
	on_counter_gain.emit(counter_gained)
	counter += counter_gained
	on_counter_change.emit(counter)

func add_shield(shield_gained: int) -> void:
	on_shield_gain.emit(shield_gained)
	shield += shield_gained
	on_shield_change.emit(shield)

func handle_damage(damage: int, enemy : Enemy) -> int:
	if damage <= counter:
		on_counter_triggered.emit(int(counter * counter_buff * counter_relic_buff))
		trigger_countered_effect.emit(enemy)
		counter_buff = 1
		counter = 0
		on_counter_change.emit(counter)
		return 0
	
	if damage <= shield:
		trigger_blocked_effect.emit(enemy)
		on_attack_blocked.emit(damage, shield)
		on_shield_lost.emit(damage)
		shield -= damage
		if shield < minimum_shield:
			shield = 0 + minimum_shield
		on_shield_change.emit(shield)
		return 0
	else:
		if yellow_shield_buff_flag and counter > 0:
			var shield_counter_buff = int(0.5 * counter)
			shield += shield_counter_buff
			print("yellow shield buff blocked : %s" %shield_counter_buff)
		on_shield_lost.emit(shield)
		damage -= shield
		shield = 0 + minimum_shield
		on_shield_change.emit(shield)
		return damage

func lose_life() -> void:
	lives -= 1
	shield = 0 + minimum_shield
	counter = 0
	if lives <= 0:
		print("game_over")
		on_player_death.emit()
	else:
		on_life_lost.emit()

func increase_counter_buff(new_buff : int) -> void:
	counter_buff += new_buff

func add_relic_counter_buff(new_buff : float) -> void:
	counter_relic_buff = new_buff

func add_minimum_shield(amount : int) -> void:
	minimum_shield += amount
	print("min shield : %s" % minimum_shield)

func reset_counter_and_shield(reset_minimum := true) -> void:
	counter = 0
	shield = 0
	on_shield_change.emit(shield)
	on_counter_change.emit(counter)
	if reset_minimum:
		minimum_shield = 0

func gain_yellow_shield_relic_buff():
	yellow_shield_buff_flag = true
	print("yellow shielf buff gained")
