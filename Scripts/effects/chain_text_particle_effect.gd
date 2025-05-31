extends Node2D

class_name ChainParticleEffect

@export var starting_font_size : int = 50
@export var  font_grow : int = 15
var text : String
@onready var effect_active = false
var text_transparency

func create(chain_length : int = 1):
	text = ("Chain %s" % chain_length) + "!"
	$SubViewport/Label.text = text
	$SubViewport/Label.add_theme_font_size_override("normal_font_size", starting_font_size + ((chain_length - 1) * font_grow))
	$CPUParticles2D.restart()
	effect_active = true

func _physics_process(delta: float) -> void:
	pass

func _on_gpu_particles_2d_finished() -> void:
	queue_free()
