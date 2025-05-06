extends Node2D

func _ready():
	pass


func _on_timer_timeout() -> void:
	
	return
	$GridManager.grid[2][2].set_puyo($GridManager/TestPuyo)
	$GridManager.grid[2][2].set_type(Puyo.PUYO_TYPE.YELLOW)
	$GridManager.grid[1][2].set_puyo($GridManager/TestPuyo1)
	$GridManager.grid[1][2].set_type(Puyo.PUYO_TYPE.YELLOW)
	$GridManager.grid[3][2].set_puyo($GridManager/TestPuyo2)
	$GridManager.grid[3][2].set_type(Puyo.PUYO_TYPE.YELLOW)
	$GridManager.grid[2][3].set_puyo($GridManager/TestPuyo3)
	$GridManager.grid[2][3].set_type(Puyo.PUYO_TYPE.YELLOW)
	$GridManager.grid[2][4].set_puyo($GridManager/TestPuyo4)
	$GridManager.grid[2][4].set_type(Puyo.PUYO_TYPE.YELLOW)
	
	$GridManager.grid[1][4].set_puyo($GridManager/TestPuyo5)
	$GridManager.grid[1][4].set_type(Puyo.PUYO_TYPE.RED)
	$GridManager.grid[3][4].set_puyo($GridManager/TestPuyo6)
	$GridManager.grid[3][4].set_type(Puyo.PUYO_TYPE.RED)
	$GridManager.grid[2][5].set_puyo($GridManager/TestPuyo7)
	$GridManager.grid[2][5].set_type(Puyo.PUYO_TYPE.RED)
	$GridManager.grid[3][5].set_puyo($GridManager/TestPuyo8)
	$GridManager.grid[3][5].set_type(Puyo.PUYO_TYPE.RED)
	
	$GridManager.grid[4][2].set_puyo($GridManager/TestPuyo9)
	$GridManager.grid[4][2].set_type(Puyo.PUYO_TYPE.BLUE)
	$GridManager.grid[5][2].set_puyo($GridManager/TestPuyo10)
	$GridManager.grid[5][2].set_type(Puyo.PUYO_TYPE.BLUE)
	$GridManager.grid[5][4].set_puyo($GridManager/TestPuyo11)
	$GridManager.grid[5][4].set_type(Puyo.PUYO_TYPE.BLUE)
	$GridManager.grid[5][3].set_puyo($GridManager/TestPuyo12)
	$GridManager.grid[5][3].set_type(Puyo.PUYO_TYPE.BLUE)
	$GridManager.grid[5][5].set_puyo($GridManager/TestPuyo18)
	$GridManager.grid[5][5].set_type(Puyo.PUYO_TYPE.BLUE)
	
	$GridManager.grid[1][5].set_puyo($GridManager/TestPuyo13)
	$GridManager.grid[1][5].set_type(Puyo.PUYO_TYPE.GREEN)
	$GridManager.grid[0][6].set_puyo($GridManager/TestPuyo14)
	$GridManager.grid[0][6].set_type(Puyo.PUYO_TYPE.GREEN)
	$GridManager.grid[1][6].set_puyo($GridManager/TestPuyo15)
	$GridManager.grid[1][6].set_type(Puyo.PUYO_TYPE.GREEN)
	$GridManager.grid[2][6].set_puyo($GridManager/TestPuyo16)
	$GridManager.grid[2][6].set_type(Puyo.PUYO_TYPE.GREEN)
	$GridManager.grid[1][7].set_puyo($GridManager/TestPuyo17)
	$GridManager.grid[1][7].set_type(Puyo.PUYO_TYPE.GREEN)
	#var groups: Array =  $GridManager.get_grouped_puyos()
	#$GridManager.down_tick()
	
	#for i in $GridManager.board_check():
		#for j in i:
			#print(j.position)
			#print(j.get_color())
	
	#print(groups)
		#print (str("found a group of ", group.size(), " ", group[0].get_type, " puyos spotted"))
	
	pass
