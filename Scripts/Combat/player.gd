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

var lives : int = 3
var shield : int = 0
var counter : int = 0

var counter_buff : int = 1
var counter_relic_buff : int = 1

var minimum_shield : int = 0

func _ready():
	on_set_life_to.emit(lives)

func receive_attack(attack: EnemyAttack) -> void:
	on_player_attacked.emit()
	var damage_taken = 0
	for i in range(attack.number_of_swings):
		damage_taken += handle_damage(attack.damage)
	#add shield = 0 if we want to have the shield reset between attacks
	#if damage_taken > 0: #resets counter if damage is taken
		#counter = 0
		#if we want counter to reset between attacks no matter what, just remove condition
	on_player_damage_taken.emit(damage_taken, attack.attack_type)

func add_counter(counter_gained: int) -> void:
	on_counter_gain.emit(counter_gained)
	counter += counter_gained
	on_counter_change.emit(counter)

func add_shield(shield_gained: int) -> void:
	on_shield_gain.emit(shield_gained)
	shield += shield_gained
	on_shield_change.emit(shield)

func handle_damage(damage: int) -> int:
	if damage <= counter:
		on_counter_triggered.emit(counter * counter_buff * counter_relic_buff)
		counter_buff = 1
		counter = 0
		on_counter_change.emit(counter)
		return 0
	
	if damage <= shield:
		on_attack_blocked.emit(damage, shield)
		on_shield_lost.emit(damage)
		shield -= damage
		if shield < minimum_shield:
			shield = 0 + minimum_shield
		on_shield_change.emit(shield)
		return 0
	else:
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

func add_relic_counter_buff(new_buff : int) -> void:
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
