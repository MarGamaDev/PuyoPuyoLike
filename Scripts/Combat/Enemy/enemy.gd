class_name Enemy
extends Node2D

enum AttackBehaviour {
	RANDOM,
	ORDERED
}
@export var attack_behaviour : AttackBehaviour

@export var enemy_data: EnemyData
@export var attacks : Array[EnemyAttack]
var instance_data : EnemyData
var current_attack : EnemyAttack

var attack_index = 0
var attack_countdown := 0

signal on_taking_player_attack()
signal on_attacking_player(enemy_attack: EnemyAttack)
signal on_death()
signal on_take_damage()
signal on_taking_turn()

@onready var combat_manager: Node
@onready var combat_effects_manager: Node

func _ready() -> void:
	
	instance_data = enemy_data.duplicate(true);
	$Sprite.texture = instance_data.sprite
	$Healthbar.max_value = instance_data.health
	$Healthbar.value = instance_data.health
	
	combat_manager = get_node("/root/Combat")
	combat_manager.connect("on_aoe_damage_dealt", take_player_attack)
	combat_manager.connect("on_player_turn_taken", handle_turn)
	combat_manager.connect("on_player_life_lost", reset_attack_timer)
	combat_manager.register_enemy(self)
	
	combat_effects_manager = get_node("/root/Combat/CombatEffectsManager")
	
	current_attack = attacks[0]

func handle_turn() -> void:
	on_taking_turn.emit()
	
	attack_countdown += 1
	if attack_countdown >= current_attack.number_of_turns_till_swing:
		unleash_attack()
	$Intent.set_indicator(current_attack, current_attack.number_of_turns_till_swing - attack_countdown)

func determine_next_attack() -> void:
	match attack_behaviour:
		AttackBehaviour.ORDERED:
			attack_index += 1
			attack_index %= attacks.size()
		AttackBehaviour.RANDOM:
			attack_index = randi_range(0, attacks.size() - 1)
	current_attack = attacks[attack_index]

func unleash_attack() ->void:
	on_attacking_player.emit(current_attack)
	attack_countdown = 0
	determine_next_attack()

func take_player_attack(damage: int) -> void:
	on_taking_player_attack.emit()
	take_damage(damage)

func take_damage(damage: int) -> void:
	on_take_damage.emit()
	instance_data.health -= damage
	$Healthbar.value = instance_data.health	
	if damage > 0:
		combat_effects_manager.create_damage_number_effect(damage, global_position)
		$HurtFlashAnim.play("animation")
	if instance_data.health <= 0:
		die()

func die() -> void:
	on_death.emit()
	# add in animation
	combat_manager.deregister_enemy(self)
	queue_free()

func reset_attack_timer() -> void:
	attack_countdown = 0
	$Intent.set_indicator(current_attack, current_attack.number_of_turns_till_swing - attack_countdown)

func set_as_selected(is_selected: bool) -> void:
	$Selector.visible = is_selected
	if is_selected:
		combat_manager.connect("on_targeted_damage_dealt", take_player_attack)
	elif combat_manager.is_connected("on_targeted_damage_dealt", take_player_attack):
		combat_manager.disconnect("on_targeted_damage_dealt", take_player_attack)
