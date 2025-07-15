extends Node2D

class_name PuyoDeckManager

signal on_puyo_deckbuiling_over
signal on_change_puyo_pool(pair_to_change : Array, to_change_to : Array)

@onready var deckbuilding_interface : CanvasLayer = $PuyoDeckEditorInterface
@onready var pair_selection_window : Control = $PuyoDeckEditorInterface/PuyoChoicesFrame
@onready var puyo_selection_window : Control = $PuyoDeckEditorInterface/SelectedPuyoFrame

var puyo_pool : Array[Array] = []

var current_selected_pair : Array = []
var current_selected_button_index = 0 #can be 0 or 1
var puyo_selected_flag = false
var pre_change_pair = [0,0]

@export var single_swap_flag = true

var puyo_sprites = {
	2 : preload("res://Art/puyo elements/Puyo_Blue.png"),
	3 : preload("res://Art/puyo elements/Puyo_Green.png"),
	4 : preload("res://Art/puyo elements/Puyo_Red.png"),
	5 : preload("res://Art/puyo elements/Puyo_Yellow.png")
}

@onready var puyo_pair_buttons : Array[Node] = $PuyoDeckEditorInterface/PuyoChoicesFrame/PuyoChoices.get_children()
@onready var selected_puyo_button_textures: Array[TextureRect] = [$PuyoDeckEditorInterface/SelectedPuyoFrame/PuyoButton1/TextureRect, $PuyoDeckEditorInterface/SelectedPuyoFrame/PuyoButton2/TextureRect]

func _ready():
	deckbuilding_interface.hide()
	for button : PuyoPairButton in puyo_pair_buttons:
		button.on_pair_chosen.connect(_on_pair_chosen)
		pass

func open_deckbuilding_menu():
	puyo_selected_flag = false
	deckbuilding_interface.show()
	pair_selection_window.show()
	puyo_selection_window.hide()

func _on_test_button_pressed() -> void:
	deckbuilding_interface.hide()
	on_puyo_deckbuiling_over.emit()
	pass # Replace with function body.

func _on_pair_chosen(pair : Array) -> void:
	pair_selection_window.hide()
	puyo_selection_window.show()
	selected_puyo_button_textures[0].texture = puyo_sprites[pair[0]]
	selected_puyo_button_textures[1].texture = puyo_sprites[pair[1]]
	current_selected_pair = pair
	pre_change_pair[0] = pair[0]
	pre_change_pair[1] = pair[1]
	
func initialize_puyo_choices():
	var button_counter = 0
	for puyo_option : PuyoPairButton in puyo_pair_buttons:
		var puyo_texture_rects = puyo_option.get_children()
		var current_pair = puyo_pool[button_counter]
		puyo_texture_rects[0].texture = puyo_sprites[current_pair[0]]
		puyo_texture_rects[1].texture = puyo_sprites[current_pair[1]]
		button_counter += 1
		puyo_option.initialize_button(current_pair)
	
	var blue_count = 0
	var yellow_count = 0
	var red_count = 0
	var green_count = 0
	for i in puyo_pool:
		for j in i:
			match j:
				2:
					blue_count += 1
				3: 
					green_count += 1
				4:
					red_count += 1
				5:
					yellow_count +=1
					
	$PuyoDeckEditorInterface/PuyoStatLabel.text = "black bile: " + str(blue_count) +", phlegm: " + str(green_count) + ", blood: " + str(red_count) + ", yellow bile: " + str(yellow_count)

func _on_puyo_pool_updated(puyos: Array[Array]) -> void:
	puyo_pool = puyos
	initialize_puyo_choices()


func _on_puyo_button_1_pressed() -> void:
	puyo_selected_flag = true
	current_selected_button_index = 0
	$PuyoDeckEditorInterface/SelectedPuyoFrame/SelectedTestLabel.show()
	$PuyoDeckEditorInterface/SelectedPuyoFrame/SelectedTestLabel2.hide()
	if single_swap_flag:
		current_selected_pair[1] = pre_change_pair[1]
		selected_puyo_button_textures[1].texture = puyo_sprites[pre_change_pair[1]]

func _on_puyo_button_2_pressed() -> void:
	puyo_selected_flag = true
	current_selected_button_index = 1
	$PuyoDeckEditorInterface/SelectedPuyoFrame/SelectedTestLabel.hide()
	$PuyoDeckEditorInterface/SelectedPuyoFrame/SelectedTestLabel2.show()
	if single_swap_flag:
		current_selected_pair[0] = pre_change_pair[0]
		selected_puyo_button_textures[0].texture = puyo_sprites[pre_change_pair[0]]

func swap_colors(new_color : int):
	if puyo_selected_flag:
		current_selected_pair[current_selected_button_index] = new_color
		selected_puyo_button_textures[current_selected_button_index].texture = puyo_sprites[new_color]

func _on_blue_swap_button_pressed() -> void:
	swap_colors(2)

func _on_green_swap_button_pressed() -> void:
	swap_colors(3)

func _on_red_swap_button_pressed() -> void:
	swap_colors(4)

func _on_yellow_swap_button_pressed() -> void:
	swap_colors(5)

func _on_finished_button_pressed() -> void:
	deckbuilding_interface.hide()
	$PuyoDeckEditorInterface/SelectedPuyoFrame/SelectedTestLabel.hide()
	$PuyoDeckEditorInterface/SelectedPuyoFrame/SelectedTestLabel2.hide()
	on_change_puyo_pool.emit(pre_change_pair, current_selected_pair)
	on_puyo_deckbuiling_over.emit()
	


func _on_puyo_back_button_pressed() -> void:
	$PuyoDeckEditorInterface/SelectedPuyoFrame/SelectedTestLabel.hide()
	$PuyoDeckEditorInterface/SelectedPuyoFrame/SelectedTestLabel2.hide()
	current_selected_pair[1] = pre_change_pair[1]
	selected_puyo_button_textures[1].texture = puyo_sprites[pre_change_pair[1]]
	current_selected_pair[0] = pre_change_pair[0]
	selected_puyo_button_textures[0].texture = puyo_sprites[pre_change_pair[0]]
	current_selected_pair = []
	puyo_selected_flag = false
	deckbuilding_interface.show()
	pair_selection_window.show()
	puyo_selection_window.hide()


func _on_skip_button_pressed() -> void:
	deckbuilding_interface.hide()
	$PuyoDeckEditorInterface/SelectedPuyoFrame/SelectedTestLabel.hide()
	$PuyoDeckEditorInterface/SelectedPuyoFrame/SelectedTestLabel2.hide()
	on_puyo_deckbuiling_over.emit()
