extends CanvasLayer

class_name MapScreen

signal option_chosen(option : int)

func _on_option_chosen():
	option_chosen.emit(0)
