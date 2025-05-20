extends Node2D

var started : bool = false
@export var particle_speed = 100

func _physics_process(delta: float) -> void:
	if started:
		$Path2D/PathFollow2D.progress += particle_speed * delta

func _ready():
	started = true
