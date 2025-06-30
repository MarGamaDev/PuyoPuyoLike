class_name Enemy
extends Node2D

signal wait_for_animation

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
signal on_attacking_player(enemy_attack: EnemyAttack, enemy: Enemy)
signal on_death()
signal on_take_damage()
signal on_taking_turn()
signal trigger_death_effect(position : Vector2)

@onready var combat_manager: Node
@onready var combat_effects_manager: CombatEffectsManager

var health_to_display : int = 0
var damage_number_effect_queue : Array[int] = []
var death_flag = false
@export var starting_delay_amount : int = 2

var health_suffix = " / 100"

var enemy_scale : Vector2
var enemy_position : Vector2

func _ready() -> void:
	instance_data = enemy_data.duplicate(true);
	instance_data.health += DifficultyManager.get_health_addition()
	$Sprite.texture = instance_data.sprite
	enemy_scale = $Sprite.scale
	#$Sprite.set_modulate(instance_data.color_filter)
	$Healthbar.max_value = instance_data.health
	$Healthbar.value = instance_data.health
	health_suffix = "/ " + str(instance_data.health)
	$Healthbar/HealthLabel.text = str(instance_data.health) + health_suffix
	health_to_display = instance_data.health
	
	combat_manager = get_node("/root/Combat")
	combat_manager.connect("on_aoe_damage_dealt", take_player_attack)
	combat_manager.connect("on_player_turn_taken", handle_turn)
	combat_manager.connect("on_player_life_lost", reset_attack_timer)
	combat_manager.connect("on_delay_enemy_attack", add_to_timer)
	combat_manager.register_enemy(self)
	
	combat_effects_manager = get_node("/root/Combat/CombatEffectsManager")
	combat_effects_manager.damage_effect_hit.connect(update_damage_visually)
	trigger_death_effect.connect(combat_effects_manager._create_heart_explosion)
	
	current_attack = attacks[0]
	attack_countdown = attack_countdown + randi_range(-1, 1)
	starting_delay()

func handle_turn() -> void:
	on_taking_turn.emit()
	
	attack_countdown += 1
	if current_attack.number_of_turns_till_swing - attack_countdown == 4:
		start_attack_signalling()
	if attack_countdown >= current_attack.number_of_turns_till_swing:
		unleash_attack()
		stop_attack_signalling()
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
	on_attacking_player.emit(current_attack, self)
	$AttackAnimation.play("attack")
	attack_countdown = 0
	determine_next_attack()

func take_player_attack(damage: int) -> void:
	on_taking_player_attack.emit()
	take_damage(damage)

func take_damage(damage: int) -> void:
	on_take_damage.emit()
	instance_data.health -= damage
	if damage > 0:
		damage_number_effect_queue.append(damage)
	if instance_data.health <= 0 and death_flag == false:
		die()

func die() -> void:
	death_flag = true
	await wait_for_animation
	on_death.emit()
	trigger_death_effect.emit(self.global_position)
	combat_manager.deregister_enemy(self)
	queue_free()

func reset_attack_timer() -> void:
	attack_countdown = randi_range(-1, 1)
	$Intent.set_indicator(current_attack, current_attack.number_of_turns_till_swing - attack_countdown)

func set_as_selected(is_selected: bool) -> void:
	$Selector.visible = is_selected
	if is_selected:
		combat_manager.connect("on_targeted_damage_dealt", take_player_attack)
	elif combat_manager.is_connected("on_targeted_damage_dealt", take_player_attack):
		combat_manager.disconnect("on_targeted_damage_dealt", take_player_attack)

func add_to_timer(amount_to_add : int) -> void:
	attack_countdown = attack_countdown - amount_to_add

func update_damage_visually():
	#print(damage_number_effect_queue.size())
	if damage_number_effect_queue.size() == 0:
		return
	else:
		var new_damage = damage_number_effect_queue.pop_front()
		health_to_display -= new_damage
		$Healthbar/HealthLabel.text = str(health_to_display) + health_suffix
		$Healthbar.value = health_to_display
		combat_effects_manager.create_damage_number_effect(new_damage, global_position)
		$HurtFlashAnim.play("animation")
		wait_for_animation.emit()
		
func play_entrance_animation():
	$AnimationPlayer.play("EntranceAnimation")

func starting_delay():
	add_to_timer(starting_delay_amount)
	$Intent.set_indicator(current_attack, current_attack.number_of_turns_till_swing - attack_countdown)
	pass


func reset_scale_and_position(unused : StringName):
	$Sprite.scale = enemy_scale
	

func start_attack_signalling():
	$AttackSignal.play("ready_to_attack")

func stop_attack_signalling():
	$AttackSignal.stop()
