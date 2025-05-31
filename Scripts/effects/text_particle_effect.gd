extends Node2D

class_name TextParticleEffect

@onready var effect_active = false
var text_transparency

var boss_effect_flag = false

func create(text : Variant):
	if text is int:
		text = str(text)
	$SubViewport/Label.text = text
	$GPUParticles2D.restart()
	effect_active = true

func _physics_process(delta: float) -> void:
	pass

func _on_gpu_particles_2d_finished() -> void:
	if boss_effect_flag == false:
		queue_free()

func create_blocked_effect():
	$SubViewport/Label.text = "Blocked!"
	$SubViewport/Label.add_theme_font_size_override("normal_font_size", 45)
	$SubViewport/Label.add_theme_color_override("font_outline_color", Color(0,0,255))
	$GPUParticles2D.process_material.emission_shape = ParticleProcessMaterial.EmissionShape.EMISSION_SHAPE_POINT
	$GPUParticles2D.restart()
	effect_active = true

func create_counter_effect():
	$SubViewport/Label.text = "Countered!"
	$SubViewport/Label.add_theme_font_size_override("normal_font_size", 45)
	$SubViewport/Label.add_theme_color_override("font_outline_color", Color(255,255,0))
	$GPUParticles2D.process_material.emission_shape = ParticleProcessMaterial.EmissionShape.EMISSION_SHAPE_POINT
	$GPUParticles2D.restart()
	effect_active = true

func create_boss_effect():
	show()
	$SubViewport/Label.text = "Boss fight!"
	$SubViewport/Label.add_theme_color_override("font_outline_color", Color(255,0,0))
	$SubViewport/Label.add_theme_font_size_override("normal_font_size", 45)
	$GPUParticles2D.process_material.emission_shape = ParticleProcessMaterial.EmissionShape.EMISSION_SHAPE_POINT
	$GPUParticles2D.restart()
	effect_active = true
