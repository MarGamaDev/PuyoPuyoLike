extends CPUParticles2D

var sprite_path_prefix : String = "res://Art/spell elements/SpellRunes/puyo-spell"
var sprite_path_suffix : String = "=.png"
var sprite_path : String

func _ready():
	sprite_path = sprite_path_prefix + str(randi_range(1,12)) + sprite_path_suffix
	texture = load(sprite_path)
	restart()

func start():
	pass

func _on_finished() -> void:
	queue_free()
