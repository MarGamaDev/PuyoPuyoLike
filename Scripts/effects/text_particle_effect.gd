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
