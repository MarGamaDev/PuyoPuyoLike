class_name RelicManager extends Node

func _ready():
	add_relic(load("res://Resources/RelicData/afterburner.tres"))

func add_relic(relic_data: RelicData) -> void:
	var new_relic = await load(relic_data.file_path).instantiate()
	add_child(new_relic)
	#new_relic.reparent(self)
	new_relic.initialize()
	add_relic_visual(relic_data.sprite)
	pass

func add_relic_visual(sprite: Texture) -> void:
	var new_visual = TextureRect.new()
	new_visual.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	new_visual.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	new_visual.texture = sprite
	$CanvasLayer/RelicContainer.add_child(new_visual)
	pass
