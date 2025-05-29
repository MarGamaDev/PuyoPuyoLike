extends GPUParticles2D

func start(type : Puyo.PUYO_TYPE = Puyo.PUYO_TYPE.UNDEFINED):
	match type:
		Puyo.PUYO_TYPE.YELLOW:
			set_modulate(Color(1, 1, 0))
		Puyo.PUYO_TYPE.BLUE:
			set_modulate(Color(0, 0, 1))
		Puyo.PUYO_TYPE.RED:
			set_modulate(Color(1, 0, 0))
		Puyo.PUYO_TYPE.GREEN:
			set_modulate(Color(0, 1, 0))
		Puyo.PUYO_TYPE.JUNK:
			set_modulate(Color(1.5,1.5,1.5))
	restart()

func _on_timer_timeout() -> void:
	queue_free()
