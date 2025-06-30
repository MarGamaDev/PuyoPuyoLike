extends TextureRect

class_name RelicButton

signal on_relic_selected(relic : RelicData)

var relic_data : RelicData

func initialize(data : RelicData):
	#print("initialize")
	relic_data = data
	texture = relic_data.sprite


func _on_texture_rect_pressed() -> void:
	on_relic_selected.emit(relic_data)
