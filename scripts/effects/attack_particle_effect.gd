extends Node2D

class_name AttackParticleEffect

signal on_reaching_path_end()

var effect_sprite_dictionary = {
	AttackEffectData.EFFECT_TYPE.PLAYER_RED : "res://Placeholder Art/puyo_red.png",
	AttackEffectData.EFFECT_TYPE.PLAYER_GREEN : "res://Placeholder Art/puyo_green.png",
	AttackEffectData.EFFECT_TYPE.PLAYER_BLUE : "res://Placeholder Art/puyo_blue.png",
	AttackEffectData.EFFECT_TYPE.PLAYER_YELLOW : "res://Placeholder Art/puyo_yellow.png",
	AttackEffectData.EFFECT_TYPE.JUNK : "res://Placeholder Art/puyo_junk.png"
}

@export var particle_accelleration : float = 1.8
@export var particle_speed : float = 5
@export var max_particle_speed : float = 40
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

@onready var particle_effect : GPUParticles2D = $Path2D/PathFollow2D/EndEffect

func _physics_process(delta: float) -> void:
	if started:
		particle_speed = lerp(particle_speed, max_particle_speed, delta * particle_accelleration)
		#$Path2D/PathFollow2D.progress = lerp($Path2D/PathFollow2D.progress, curve_length, particle_speed * delta)
		$Path2D/PathFollow2D.progress += particle_speed
		if $Path2D/PathFollow2D.progress_ratio >= 0.975:
			started = false
			play_particle_effect()
			$Path2D/PathFollow2D/ProjectileSprite.hide()

func _ready():
	min_curve_angle_degrees = deg_to_rad(min_curve_angle_degrees)
	max_curve_angle_degrees = deg_to_rad(max_curve_angle_degrees)
	#create_effect(Vector2(0,0), Vector2(300,300), AttackEffectData.EFFECT_TYPE.PLAYER_RED)

func create_effect(start_point : Vector2, end_point : Vector2, effect_type: AttackEffectData.EFFECT_TYPE):
	set_points(start_point, end_point)
	$Path2D/PathFollow2D/ProjectileSprite.texture = load(effect_sprite_dictionary[effect_type])
	started = true
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
	particle_effect.restart()

func _on_end_effect_finished() -> void:
	print("effect done")
	await get_tree().create_timer(0.3).timeout
	queue_free()
