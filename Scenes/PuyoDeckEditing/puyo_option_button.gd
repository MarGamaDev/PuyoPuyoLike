extends Button

class_name PuyoPairButton

signal on_pair_chosen(pair : Array)

var held_puyo_types : Array = [0,0]

func initialize_button(new_types : Array):
	held_puyo_types = new_types

func _on_pressed() -> void:
	on_pair_chosen.emit(held_puyo_types)
	pass # Replace with function body.

func turn_off_button_functionality():
	disabled = true
