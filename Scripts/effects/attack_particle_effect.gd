extends Node2D

class_name AttackParticleEffect

signal on_reaching_path_end()
signal on_damage_effect_hit

var effect_sprite_dictionary = {
	AttackEffectData.EFFECT_TYPE.PLAYER_RED : "res://Art/puyo elements/Puyo_Red.png",
	AttackEffectData.EFFECT_TYPE.PLAYER_GREEN : "res://Art/puyo elements/Puyo_Green.png",
	AttackEffectData.EFFECT_TYPE.PLAYER_BLUE : "res://Art/puyo elements/Puyo_Blue.png",
	AttackEffectData.EFFECT_TYPE.PLAYER_YELLOW : "res://Art/puyo elements/Puyo_Yellow.png",
	AttackEffectData.EFFECT_TYPE.JUNK : "res://Art/puyo elements/Puyo_Junk.png"
}

@export var particle_accelleration : float = 2
@export var particle_speed : float = 5
@export var max_particle_speed : float = 60
@export var min_curve_angle_degrees : float = 35
@export var max_curve_angle_degrees : float = 90
@export var min_curve_intensity : float = 150
@export var max_curve_intensity : float = 350
#@export var min_curve_start_distance : float = 0.2
#@export var max_curve_start_distance : float = 0.8
#@export var min_curve_point_offset : float = 25
#@export var max_curve_point_offset : float = 150

var started : bool = false
var start_point : Vector2
var end_point : Vector2
var curve_point_offset : float = 0
var curve_length : float
var effect_type : AttackEffectData.EFFECT_TYPE
var damage_flag = false
var is_spell = false

@onready var spell_end_effect : GPUParticles2D = $Path2D/PathFollow2D/SpellEndEffect
@onready var normal_end_effect : GPUParticles2D = $Path2D/PathFollow2D/NormalEndEffect

func _physics_process(delta: float) -> void:
	if started:
		particle_speed = lerp(particle_speed, max_particle_speed, delta * particle_accelleration)
		#$Path2D/PathFollow2D.progress = lerp($Path2D/PathFollow2D.progress, curve_length, particle_speed * delta)
		$Path2D/PathFollow2D.progress += particle_speed
		if $Path2D/PathFollow2D.progress_ratio >= 0.975:
			started = false
			if damage_flag:
				on_damage_effect_hit.emit()
			$Path2D.curve.clear_points()
			play_particle_effect()
			$Path2D/PathFollow2D/ProjectileSprite.hide()

func _ready():
	min_curve_angle_degrees = deg_to_rad(min_curve_angle_degrees)
	max_curve_angle_degrees = deg_to_rad(max_curve_angle_degrees)
	#create_effect(Vector2(0,0), Vector2(300,300), AttackEffectData.EFFECT_TYPE.PLAYER_RED)

func create_effect(start_point : Vector2, end_point : Vector2, effect_type: AttackEffectData.EFFECT_TYPE, new_damage_flag = false):
	set_points(start_point, end_point)
	$Path2D/PathFollow2D/ProjectileSprite.texture = load(effect_sprite_dictionary[effect_type])
	started = true
	damage_flag = new_damage_flag
	pass

func create_spell_effect(start_point : Vector2, end_point : Vector2, effect_type: AttackEffectData.EFFECT_TYPE, new_damage_flag = false):
	set_points(start_point, end_point)
	$Path2D/PathFollow2D/ProjectileSprite.texture = load(effect_sprite_dictionary[effect_type])
	$Path2D/PathFollow2D/EndEffect.texture = load("res://Art/spell elements/SpellRunes/puyo-spell" + str(randi_range(1,12)) + ".png")
	started = true
	damage_flag = new_damage_flag
	is_spell = true
	pass

func set_points(start : Vector2, end : Vector2):
	start_point = start
	end_point = end
	$Path2D.curve.add_point(start_point)
	$Path2D.curve.add_point(end_point)
	
	var direction_of_travel = end - start
	direction_of_travel = direction_of_travel.normalized()
	var random_angle = randf_range(min_curve_angle_degrees, max_curve_angle_degrees)
	if randi_range(0,1) == 0:
		random_angle *= -1
	var curve_direction = direction_of_travel.rotated(random_angle)
	curve_direction *= randf_range(min_curve_intensity, max_curve_intensity)
	
	$Path2D.curve.set_point_out(0, curve_direction)
	
	curve_length = $Path2D.curve.get_baked_length()

func play_particle_effect():
	if is_spell:
		spell_end_effect.restart()
	else:
		normal_end_effect.restart()

func _on_end_effect_finished() -> void:
	print("effect done")
	await get_tree().create_timer(0.3).timeout
	queue_free()
