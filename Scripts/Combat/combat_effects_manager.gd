extends Node2D
class_name CombatEffectsManager

signal damage_effect_hit

var damage_text_scene: PackedScene = preload("res://Scenes/effects/text_particle_effect.tscn")
var attack_effect_scene : PackedScene = preload("res://Scenes/effects/attack_particle_effect.tscn")
var heart_explosion_scene : PackedScene = preload("res://Scenes/effects/heart_explosion_effect.tscn")
var chain_text_scene: PackedScene = preload("res://Scenes/effects/chain_text_particle_effect.tscn")

@onready var player_location : Vector2 = $Markers/PlayerLocation.position
@onready var shield_location_marker :Vector2 = $Markers/PlayerShieldLocation.global_position
@onready var counter_location_marker :Vector2 = $Markers/PlayerCounterLocation.global_position
@onready var junk_indicator_marker : Vector2 = $Markers/JunkIndicatorLocation.global_position
@onready var combat_manager : CombatManager = get_node("/root/Combat")
##todo: make 

func create_damage_number_effect(text: Variant, effect_position: Vector2):
	var new_text_effect : TextParticleEffect = damage_text_scene.instantiate()
	new_text_effect.position = effect_position
	add_child(new_text_effect)
	new_text_effect.create(text)

func create_chain_text_effect(chain : int):
	var new_effect = chain_text_scene.instantiate()
	$PuyoAttackEffectLayer.add_child(new_effect)
	new_effect.global_position = $Markers/ChainMarker.global_position
	new_effect.create(chain)
	pass

func create_player_attack_effect(puyos : Array, chain : int):
	create_chain_text_effect(chain)
	var puyo_type : Puyo.PUYO_TYPE = puyos[2].puyo.puyo_type
	var puyo_position : Vector2 = puyos[0].puyo.global_position
	var attack_type : AttackEffectData.EFFECT_TYPE
	match puyo_type:
		Puyo.PUYO_TYPE.RED:
			create_red_attack(puyo_position)
		Puyo.PUYO_TYPE.YELLOW:
			create_counter_puyo_effect(puyo_position)
		Puyo.PUYO_TYPE.BLUE:
			create_shield_puyo_effect(puyo_position)
		Puyo.PUYO_TYPE.GREEN:
			create_green_attack(puyo_position)

func create_red_attack(start_position : Vector2):
	if combat_manager.selected_enemy != null:
		var enemy_position = combat_manager.selected_enemy.global_position
		create_attack_effect(start_position, enemy_position, AttackEffectData.EFFECT_TYPE.PLAYER_RED)

func create_green_attack(start_position : Vector2):
	if combat_manager.enemies.size() == 1:
		create_attack_effect(start_position, combat_manager.enemies[0].global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN)
	else:
		for i in combat_manager.enemies:
			create_attack_effect(start_position, i.global_position, AttackEffectData.EFFECT_TYPE.PLAYER_GREEN)

func create_shield_puyo_effect(start_position : Vector2):
	var end_position = $Markers/PlayerShieldLocation.position
	var new_attack_effect : AttackParticleEffect = attack_effect_scene.instantiate()
	$PuyoAttackEffectLayer.add_child(new_attack_effect)
	new_attack_effect.create_effect(start_position, end_position, AttackEffectData.EFFECT_TYPE.PLAYER_BLUE)

func create_counter_puyo_effect(start_position : Vector2):
	var end_position = $Markers/PlayerCounterLocation.position
	var new_attack_effect : AttackParticleEffect = attack_effect_scene.instantiate()
	$PuyoAttackEffectLayer.add_child(new_attack_effect)
	new_attack_effect.create_effect(start_position, end_position, AttackEffectData.EFFECT_TYPE.PLAYER_YELLOW)

func create_counterattack_effect():
	var start_position = $Markers/PlayerCounterLocation.position
	var enemy_position = combat_manager.selected_enemy.global_position
	create_attack_effect(start_position, enemy_position, AttackEffectData.EFFECT_TYPE.PLAYER_YELLOW)

func create_attack_effect(start_position : Vector2, end_position : Vector2, effect_type: AttackEffectData.EFFECT_TYPE):
	var new_attack_effect : AttackParticleEffect = attack_effect_scene.instantiate()
	$PuyoAttackEffectLayer.add_child(new_attack_effect)
	new_attack_effect.on_damage_effect_hit.connect(on_damage_effect_completed)
	new_attack_effect.create_effect(start_position, end_position, effect_type, true)

func on_damage_effect_completed():
	damage_effect_hit.emit()

func _on_player_on_counter_triggered(counter_amount: int) -> void:
	create_counterattack_effect()

##CAN CHANGE THIS ONCE IT'S ALL LINKED UP BETTER
func create_spell_effect(start_position : Vector2, end_position : Vector2, effect_type: AttackEffectData.EFFECT_TYPE, attack_signal_flag := true):
	var new_attack_effect : AttackParticleEffect = attack_effect_scene.instantiate()
	$PuyoAttackEffectLayer.add_child(new_attack_effect)
	new_attack_effect.on_damage_effect_hit.connect(on_damage_effect_completed)
	new_attack_effect.create_effect(start_position, end_position, effect_type, attack_signal_flag)
	
func create_relic_effect(start_position : Vector2, end_position : Vector2, effect_type: AttackEffectData.EFFECT_TYPE, attack_signal_flag := true):
	var new_attack_effect : AttackParticleEffect = attack_effect_scene.instantiate()
	$PuyoAttackEffectLayer.add_child(new_attack_effect)
	new_attack_effect.on_damage_effect_hit.connect(on_damage_effect_completed)
	new_attack_effect.create_effect(start_position, end_position, effect_type, attack_signal_flag)

func _on_player_trigger_blocked_effect(enemy : Enemy) -> void:
	if enemy == null:
		return
	var new_text_effect : TextParticleEffect = damage_text_scene.instantiate()
	new_text_effect.position = enemy.global_position
	add_child(new_text_effect)
	new_text_effect.create_blocked_effect()

func _on_player_trigger_countered_effect(enemy: Enemy) -> void:
	if enemy == null:
		return
	var new_text_effect : TextParticleEffect = damage_text_scene.instantiate()
	new_text_effect.position = enemy.global_position
	add_child(new_text_effect)
	new_text_effect.create_counter_effect()


func _on_combat_started() -> void:
	$PuyoAttackEffectLayer/combat_start_effect.start_effect()
	pass # Replace with function body.

func _create_heart_explosion(position : Vector2) -> void:
	var heart_effect = heart_explosion_scene.instantiate()
	$PuyoAttackEffectLayer.add_child(heart_effect)
	heart_effect.global_position = position
	heart_effect.start()
