class_name BaseRelic extends Node
@export var relic_data: RelicData

func initialize() -> void:
	self.name = relic_data.name
	pass
