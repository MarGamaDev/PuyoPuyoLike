extends Node2D

class_name TextParticleEffect

@onready var effect_active = false
var text_transparency

func create(text : Variant):
	if text is int:
		text = str(text)
	$SubViewport/Label.text = text
	$GPUParticles2D.restart()
	effect_active = true

func _physics_process(delta: float) -> void:
	pass

func _on_gpu_particles_2d_finished() -> void:
	queue_free()

func create_blocked_effect():
	$SubViewport/Label.text = "Blocked!"
	$SubViewport/Label.add_theme_color_override("font_outline_color", Color(0,0,255))
	$GPUParticles2D.process_material.emission_shape = ParticleProcessMaterial.EmissionShape.EMISSION_SHAPE_POINT
	$GPUParticles2D.restart()
	effect_active = true

func create_counter_effect():
	$SubViewport/Label.text = "Countered!"
	$SubViewport/Label.add_theme_color_override("font_outline_color", Color(255,255,0))
	$GPUParticles2D.process_material.emission_shape = ParticleProcessMaterial.EmissionShape.EMISSION_SHAPE_POINT
	$GPUParticles2D.restart()
	effect_active = true
