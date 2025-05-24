extends Node2D

var damage_text_scene: PackedScene = preload("res://Scenes/effects/text_particle_effect.tscn")
var attack_effect_scene : PackedScene = preload("res://Scenes/effects/attack_particle_effect.tscn")

@onready var player_location : Vector2 = $PlayerLocation.position
##todo: make 

func create_damage_number_effect(text: Variant, effect_position: Vector2):
	var new_text_effect : TextParticleEffect = damage_text_scene.instantiate()
	new_text_effect.position = effect_position
	add_child(new_text_effect)
	new_text_effect.create(text)

func create_player_attack_effect(puyos : Array, chain : int):
	return
	var puyo_type : Puyo.PUYO_TYPE = puyos[0].puyo.puyo_type
	##todo: make this get the like middle puyo's position
	var puyo_position : Vector2 = puyos[0].puyo.global_position
	var new_attack_effect : AttackParticleEffect = attack_effect_scene.instantiate()
	add_child(new_attack_effect)
	##todo: make this actually get the enemy's position and not just use a marker
	new_attack_effect.create_effect(puyo_position, $EnemyLocation.position, AttackEffectData.EFFECT_TYPE.PLAYER_RED)
	
	
	
