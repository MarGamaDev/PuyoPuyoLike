class_name CombatManager
extends Node2D

signal deal_player_damage(int)
signal add_player_shield(int)
signal add_player_counter(int)
signal on_player_turn_taken()
signal on_enemy_attack(attack: EnemyAttack)
signal on_enemy_registered(enemy: Enemy)
signal on_enemy_deregistered(enemy: Enemy)

var enemies : Array = Array()

func process_player_attack(attack : PlayerAttack) -> void:
	#print("blue: ", attack.blue)
	#print("red: ", attack.red)
	#print("green: ", attack.green)
	#print("yellow: ", attack.yellow)
	#print("chain: ", attack.chain)
	deal_player_damage.emit((attack.green + attack.red) * attack.chain)
	add_player_shield.emit(attack.blue * attack.chain)
	add_player_counter.emit(attack.yellow * attack.chain)
	pass

func end_player_turn() -> void:
	on_player_turn_taken.emit()

func process_enemy_attack(enemy_attack: EnemyAttack) -> void:
	on_enemy_attack.emit(enemy_attack)

func register_enemy(enemy : Enemy) -> void:
	print("enemy registered")
	on_enemy_registered.emit(enemy)
	enemies.push_back(enemy)
	enemy.connect("on_attacking_player", process_enemy_attack)

func deregister_enemy(enemy : Enemy) -> void:
	print("enemy deregistered")
	on_enemy_deregistered.emit(enemy)
	enemies.erase(enemy)

func _on_player_on_player_damage_taken(damage_taken: int, attack_type: EnemyAttack.EnemyAttackType) -> void:
	$PuyoManager.add_to_spawn_queue(EnemyAttackHandler.process_attack(damage_taken, attack_type))
