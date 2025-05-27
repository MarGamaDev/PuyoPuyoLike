extends Node2D

var emmitters : Array = []

func start_effect():
	$AnimationPlayer.play("fade_out")
	emmitters = get_tree().get_nodes_in_group("emmitters")
	for emitter : GPUParticles2D in emmitters:
		emitter.restart()
