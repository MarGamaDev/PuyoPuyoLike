class_name CombatManager
extends Node2D
signal deal_player_damage(int)
signal add_player_shield(int)
signal add_player_counter(int)

func process_player_attack(attack : PlayerAttack) -> void:
	print("blue: ", attack.blue)
	print("red: ", attack.red)
	print("green: ", attack.green)
	print("yellow: ", attack.yellow)
	print("chain: ", attack.chain)
	deal_player_damage.emit((attack.green + attack.red) * attack.chain)
	add_player_shield.emit(attack.blue * attack.chain)
	add_player_counter.emit(attack.yellow * attack.chain)
	pass
