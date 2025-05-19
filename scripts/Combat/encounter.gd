extends Node2D
class_name  Encounter

signal on_encounter_initialized

@export var enemy_count = 1

func _ready() -> void:
	await get_tree().create_timer(0.3).timeout
	on_encounter_initialized.emit()
