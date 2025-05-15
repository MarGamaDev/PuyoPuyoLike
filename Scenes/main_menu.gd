extends Control



func play_animations():
	$MenuPage/AnimationPlayer.play("logo")
	$MenuPage/AnimationPlayer2.play("buttons")


func _on_start_button_pressed() -> void:
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
	$MenuPage/Buttons.show()
