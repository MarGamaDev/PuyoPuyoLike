extends Node2D

func _ready():

	pass


func _on_timer_timeout() -> void:
	$GridManager.grid[2][2].set_puyo($GridManager/TestPuyo)
	$GridManager.grid[2][2].set_color(4)
	print($GridManager.grid[2][2].position)
	$GridManager/TestPuyo.set_position($GridManager.grid[2][2].position)
	pass
