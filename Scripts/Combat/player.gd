class_name Player
extends Node2D

signal on_counter_gain(counter_gained: int)
signal on_shield_gain(shield_gained: int)
signal on_shield_lost(shield_lost: int)
signal on_counter_triggered(counter_amount: int)
signal on_player_attacked
signal on_player_damage_taken(damage_taken: int, attack_type: EnemyAttack.EnemyAttackType)
signal on_life_lost
signal on_player_death

var lives : int = 3
var shield : int = 0
var counter : int = 0

func receive_attack(attack: EnemyAttack) -> void:
	on_player_attacked.emit()
	var damage_taken = 0
	for i in range(attack.number_of_swings):
		damage_taken += handle_damage(attack.damage)
	#add shield = 0 if we want to have the shield reset between attacks
	if damage_taken > 0: #resets counter if damage is taken
		counter = 0
		#if we want counter to reset between attacks no matter what, just remove condition
	on_player_damage_taken.emit(damage_taken, attack.attack_type)

func add_counter(counter_gained: int) -> void:
	on_counter_gain.emit(counter_gained)
	counter += counter_gained

func add_shield(shield_gained: int) -> void:
	on_shield_gain.emit(shield_gained)
	shield += shield_gained

func handle_damage(damage: int) -> int:
	if damage <= counter:
		##do we want the counterattack to be equal to counter or enemy damage?
		on_counter_triggered.emit(damage)
		##counter carries over for multiple attacks in a flurry
		counter -= damage
		return 0
	
	if shield == damage:
		print("attack blocked!")
		on_shield_lost.emit(shield)
		shield = 0
		return 0
	elif damage < shield:
		print("attack blocked!")
		shield -= damage
		return 0
	else:
		damage -= shield
		on_shield_lost.emit(damage - shield)
		shield = 0
		return damage
	
	return damage

func lose_life() -> void:
	lives -= 1
	if lives <= 0:
		on_player_death.emit()
	else:
		on_life_lost.emit()
