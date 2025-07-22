extends Node2D

class_name TextParticleEffect

@onready var effect_active = false
var text_transparency

var boss_effect_flag = false

func create(text : Variant):
	if text is int:
		text = str(text)
	$SubViewport/Label.text = text
	$CPUParticles2D.restart()
	effect_active = true

func _on_CPU_particles_2d_finished() -> void:
	if boss_effect_flag == false:
		queue_free()

func create_blocked_effect():
	$SubViewport/Label.text = "Blocked!"
	$SubViewport/Label.add_theme_font_size_override("normal_font_size", 45)
	$SubViewport/Label.add_theme_color_override("font_outline_color", Color(0,0,255))
	#$CPUParticles2D.process_material.emission_shape = ParticleProcessMaterial.EmissionShape.EMISSION_SHAPE_POINT
	$CPUParticles2D.restart()
	effect_active = true

func create_counter_effect():
	$SubViewport/Label.text = "Countered!"
	$SubViewport/Label.add_theme_font_size_override("normal_font_size", 45)
	$SubViewport/Label.add_theme_color_override("font_outline_color", Color(255,255,0))
	#$CPUParticles2D.process_material.emission_shape = ParticleProcessMaterial.EmissionShape.EMISSION_SHAPE_POINT
	$CPUParticles2D.restart()
	effect_active = true

func create_boss_effect():
	show()
	$SubViewport/Label.text = "Boss fight!"
	$SubViewport/Label.add_theme_color_override("font_outline_color", Color(255,0,0))
	$SubViewport/Label.add_theme_font_size_override("normal_font_size", 45)
	#$CPUParticles2D.process_material.emission_shape = ParticleProcessMaterial.EmissionShape.EMISSION_SHAPE_POINT
	$CPUParticles2D.restart()
	effect_active = true

func set_color(new_color : Color):
	$SubViewport/Label.add_theme_color_override("default_color", new_color)
	$SubViewport/Label.add_theme_color_override("font_outline_color", Color(255,255,255))

func _on_cpu_particles_2d_finished() -> void:
	pass # Replace with function body.
