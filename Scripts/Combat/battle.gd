extends MapNode

class_name Battle

@export var enemy_waves : Array[PackedScene] = []
@export var difficulty_level : int = 0
@export var boss_flag : bool = false
@export var enemy_amount : int = 0

func initialize_from_battle_data(data : BattleData):
	difficulty_level = data.difficulty_level
	boss_flag = data.is_boss
	enemy_amount = data.enemy_amount
	for i in data.wave_paths:
		enemy_waves.append(load(i))
