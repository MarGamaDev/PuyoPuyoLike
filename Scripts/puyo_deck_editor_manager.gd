extends Node2D

class_name PuyoDeckManager

signal on_puyo_deckbuiling_over

@onready var deckbuilding_interface : CanvasLayer = $PuyoDeckEditorInterface

var puyo_pool : Array[Array] = []

var puyo_sprites = {
	2 : preload("res://Art/puyo elements/Puyo_Blue.png"),
	3 : preload("res://Art/puyo elements/Puyo_Green.png"),
	4 : preload("res://Art/puyo elements/Puyo_Red.png"),
	5 : preload("res://Art/puyo elements/Puyo_Yellow.png")
}

func _ready():
	deckbuilding_interface.hide()

func open_deckbuilding_menu():
	deckbuilding_interface.show()

func _on_test_button_pressed() -> void:
	deckbuilding_interface.hide()
	on_puyo_deckbuiling_over.emit()
	pass # Replace with function body.

func initialize_puyo_choices():
	var puyo_buttons : Array[Node] = $PuyoDeckEditorInterface/PuyoChoicesFrame/PuyoChoices.get_children()
	var button_counter = 0
	for puyo_option : Button in puyo_buttons:
		var puyo_texture_rects = puyo_option.get_children()
		var current_pair = puyo_pool[button_counter]
		puyo_texture_rects[0].texture = puyo_sprites[current_pair[0]]
		puyo_texture_rects[1].texture = puyo_sprites[current_pair[1]]
		button_counter += 1

func _on_puyo_pool_updated(puyos: Array[Array]) -> void:
	puyo_pool = puyos
	initialize_puyo_choices()
