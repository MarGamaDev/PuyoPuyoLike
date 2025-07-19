extends CanvasLayer

class_name WinScreen

signal continue_run(boss_flag : bool)

func on_game_win():
	show()
	pass


func _on_continue_button_pressed() -> void:
	hide()
	get_tree().paused = false
	continue_run.emit()
	

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_death_manager_send_game_stats(popped_num: Variant, highest_chain: Variant, foes_killed: Variant, sensations_felt: Variant, favorite_color: Variant, junk_popped: Variant) -> void:
	var popped : String = "Number of humours crushed: %s" % popped_num
	var chain : String = "Highest chain: %s" % highest_chain
	var foes : String = "Foes defeated: %s" % foes_killed
	var sensations : String = "Sensations felt: %s" % sensations_felt
	var junk : String = "Toxins popped: %s" % junk_popped
	
	var favorite : String = "Favorite humour type: "
	match favorite_color:
		Puyo.PUYO_TYPE.BLUE:
			favorite = favorite + "[puyo type=bbile]Black Bile[/puyo]"
		Puyo.PUYO_TYPE.RED:
			favorite = favorite + "[puyo type=blood]Blood[/puyo]"
		Puyo.PUYO_TYPE.YELLOW:
			favorite = favorite + "[puyo type=ybile]Yellow Bile[/puyo]"
		Puyo.PUYO_TYPE.GREEN:
			favorite = favorite + "[puyo type=phlegm]Phlegm[/puyo]"
	$GameStatsLabel.text = popped + "\n" + chain + "\n" + foes + "\n" + sensations + "\n" + favorite + "\n" + junk


#number of humours popped:
#highest chain:
#foes killed:
#sensations felt:
#favorite color:
#junk popped:
