extends Node2D

signal counter_ready

@export var shield : int = 0
@export var counter : int = 0
@export var counter_max : int = 8
#var counter_flag = false


func _on_combat_add_player_counter(new_counter : int) -> void:
	counter += new_counter
	if counter >= counter_max:
		print("counter ready")
		counter_ready.emit()
		counter = 0 ##ask mar what they think about this
	#print("counter: %s" % counter)


func _on_combat_add_player_shield(new_shield : int) -> void:
	shield += new_shield
	#print("shield %s" % shield)
