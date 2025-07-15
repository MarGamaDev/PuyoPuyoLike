extends AnimatedSprite2D

class_name EnemySingleTargetAttackReticle

var sprite_width : int = 100
var sprite_height : int = 100

func create_reticle(new_pos : Vector2):
	position = Vector2.ZERO
	global_position = new_pos
	print("sprite global: %s" % global_position )
