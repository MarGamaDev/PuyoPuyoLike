extends Node2D

@export var damage_text: PackedScene

func create_damage_number_effect(text: Variant, effect_position: Vector2):
	var new_text_effect : TextParticleEffect = damage_text.instantiate()
	new_text_effect.position = effect_position
	add_child(new_text_effect)
	new_text_effect.create(text)
