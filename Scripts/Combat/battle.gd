extends Node2D

class_name Battle

@export var enemy_waves : Array[PackedScene] = []
@export var difficulty_level : int = 0
@export var boss_flag : bool = false

func initialize_from_battle_data(data : BattleData):
	difficulty_level = data.difficulty_level
	boss_flag = data.is_boss
	for i in data.wave_paths:
		enemy_waves.append(load(i))
