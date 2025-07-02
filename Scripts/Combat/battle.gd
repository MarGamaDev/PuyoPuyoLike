extends MapNode

class_name Battle

@export var enemy_waves : Array[PackedScene] = []
@export var difficulty_level : int = 0
@export var boss_flag : bool = false
@export var enemy_amount : int = 0
var battle_data : BattleData

func initialize_from_battle_data(data : BattleData):
	difficulty_level = 0
	boss_flag = false
	enemy_amount = 0
	battle_data = null
	enemy_waves = []
	
	difficulty_level = data.difficulty_level
	boss_flag = data.is_boss
	enemy_amount = data.enemy_amount
	battle_data = data
	for i in data.wave_paths:
		enemy_waves.append(load(i))
