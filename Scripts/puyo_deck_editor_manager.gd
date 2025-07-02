extends Node2D

class_name PuyoDeckManager

signal on_puyo_deckbuiling_over

@onready var deckbuilding_interface : CanvasLayer = $PuyoDeckEditorInterface

func _ready():
	deckbuilding_interface.hide()

func open_deckbuilding_menu():
	deckbuilding_interface.show()

func _on_test_button_pressed() -> void:
	deckbuilding_interface.hide()
	on_puyo_deckbuiling_over.emit()
	pass # Replace with function body.
