class_name BaseRelic extends Node
@export var relic_data: RelicData

@onready var player : Player = get_node("/root/Combat/Player")
@onready var puyo_manager : PuyoManager = get_node("/root/Combat/PuyoManager")
@onready var combat_manager : CombatManager = get_node("/root/Combat")
@onready var puyo_values : PuyoValueData = combat_manager.puyo_values
@onready var encounter_manager : EncounterManager = get_node("/root/Combat/EncounterManager")
var spell_manager
@onready var sound_manager : SoundManager = get_node("/root/Combat/SoundManager")

@onready var combat_effects : CombatEffectsManager = get_node("/root/Combat/CombatEffectsManager")

signal update_enemy_damage_visuals

func initialize() -> void:
	self.name = relic_data.name
	pass
