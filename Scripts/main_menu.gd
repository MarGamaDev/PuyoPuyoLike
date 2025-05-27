extends Control

var tutorial_page_number : int = 0
@onready var tutorial_pages : Array = [$Tutorial/TutorialOptions, $Tutorial/PuyoTutorial, $Tutorial/GameTutorial, $Tutorial/GameTutorial2]

func _ready() -> void:
	print("menu ready")
	#$MenuAnimationTimer.start(0.3)

func play_animations():
	print("anims starting")
	$MenuPage/AnimationPlayer.play("logo")
	$MenuPage/AnimationPlayer2.play("buttons")


func start_game() -> void:
	get_tree().change_scene_to_file("res://Scenes/combat.tscn")
	

func _on_options_button_pressed() -> void:
	#$MenuPage/Logo/AnimationPlayer.play_backwards("logo")
	$MenuPage/Buttons.hide()
	$OptionsPage.show()


func _on_credits_button_pressed() -> void:
	$MenuPage/Buttons.hide()
	$CreditsPage.show()
	pass # Replace with function body.

func return_to_menu():
	$CreditsPage.hide()
	$OptionsPage.hide()
	for i in tutorial_pages:
		i.hide()
	$Tutorial.hide()
	$MenuPage/Buttons.show()
	tutorial_page_number = 0

func open_tutorial():
	tutorial_page_number = 0
	$MenuPage/Buttons.hide()
	$Tutorial.show()
	$Tutorial/TutorialOptions.show()

func next_page(page_num = 0):
	tutorial_pages[tutorial_page_number].hide()
	if page_num == 0:
		tutorial_page_number += 1
	else:
		tutorial_page_number = page_num
	tutorial_pages[tutorial_page_number].show()

func last_page():
	tutorial_pages[tutorial_page_number].hide()
	tutorial_page_number -= 1
	tutorial_pages[tutorial_page_number].show()
