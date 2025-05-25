class_name RelicManager extends Node

func add_relic(new_relic: BaseRelic) -> void:
	new_relic.reparent(self)
	new_relic.initialize()
	add_relic_visual(new_relic.sprite)
	pass

func add_relic_visual(sprite: Texture) -> void:
	var new_visual = TextureRect.new()
	new_visual.texture = sprite
	$RelicContainer.add_child(new_visual)
	pass
