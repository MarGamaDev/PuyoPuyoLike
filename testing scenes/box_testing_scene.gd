extends Node2D

func _ready():

	pass


func _on_timer_timeout() -> void:
	$GridManager.grid[2][2].set_puyo($GridManager/TestPuyo)
	$GridManager.grid[2][2].set_color(4)
	pass


func _on_timer_2_timeout() -> void:
	$GridManager.move_puyo($GridManager.grid[2][2], $GridManager.grid[2][3])
