extends Node2D
class_name  Encounter

signal on_encounter_initialized

@export var enemy_count = 1
@export var boss_encounter_flag : bool = false
var enemies : Array

func _ready() -> void:
	await get_tree().create_timer(0.3).timeout
	on_encounter_initialized.emit()
	enemies = get_children()
	enemy_count = enemies.size()
	lay_out_enemies()

func lay_out_enemies():
	match enemies.size():
		1:
			for i in enemies:
				i.scale = Vector2(1,1)
			pass
		2:
			for i in enemies:
				i.scale = Vector2(1,1)
			enemies[0].position = Vector2(100, 0)
			enemies[1].position = Vector2(-100, 0)
		3:
			for i in enemies:
				i.scale = i.scale * 0.9
			enemies[0].position = Vector2(0,-20)
			enemies[1].position = Vector2(-140, 20)
			enemies[2].position = Vector2(140, 20)
		4:
			for i in enemies:
				i.scale = i.scale * 0.8
			enemies[0].position = Vector2(-50, -40)
			enemies[1].position = Vector2(-140, 25)
			enemies[2].position = Vector2(150, -40)
			enemies[3].position = Vector2(60, 15)
		5:
			for i in enemies:
				i.scale = i.scale * 0.8
			enemies[2].position = Vector2(-160, 25)
			enemies[4].position = Vector2(0, 25)
			enemies[0].position = Vector2(-90, -45)
			enemies[3].position = Vector2(160, 25)
			enemies[1].position = Vector2(90, -45)
