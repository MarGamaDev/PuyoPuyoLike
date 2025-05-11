class_name Enemy
extends Node2D
@export var enemy_data: EnemyData
@export var attacks : Array[EnemyAttack]
var instance_data : EnemyData
var current_attack : EnemyAttack

func _ready() -> void:
	instance_data = enemy_data.duplicate(true);
	$Sprite.texture = instance_data.sprite
	$Healthbar.max_value = instance_data.health
	$Healthbar.value = instance_data.health
	
	get_parent().connect("deal_player_damage", take_damage)
	pass

func _exit_tree() -> void:
	get_parent().disconnect("deal_player_damage", take_damage)
	pass

func receive_turn() -> void:
	print("enemy is taking turn")
	pass

func take_damage(damage: int) -> void:
	instance_data.health -= damage
	$Healthbar.value = instance_data.health
	print(instance_data.health)
	pass 
