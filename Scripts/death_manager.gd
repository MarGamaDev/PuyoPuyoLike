extends Node2D
class_name DeathManager

var encounter_score_tracker = 0
var foes_killed = 0
var relics_picked_up = 0
var spells_cast = 0
var spell_record_name_tracker : Array[String] = []
var spell_record_tracker : Array[int] = []
var highest_spell_name : String
var highest_spell_amount : int = 0
var highest_chain : int = 0
var puyos_popped : int = 0

func create_death_screen():
	get_tree().paused = true
	$DeathScreen.show()
	$DeathScreen/ScoreMessage.text = ("You survived %s" % encounter_score_tracker) + (" rounds, and killed %s" %foes_killed) + " foes."
	$DeathScreen/RelicSpellMessage.text = ("You felt %s" % relics_picked_up) + (" sensations, and channeled emotions %s" % spells_cast) + " times."
	get_highest_spell()
	$DeathScreen/MostCastSpell.text = ("Your most channeled emotion was %s" % highest_spell_name) + "."
	$DeathScreen/PuyoStats.text = ("Your highest chain was %s" % highest_chain) + (", and you crushed a total of %s" % puyos_popped) + " humours."
	pass

func score_increase():
	encounter_score_tracker += 1

func _on_enemy_killed(enemy: Enemy) -> void:
	foes_killed += 1

func _on_spell_cast(spell_length: int, spell_name : String) -> void:
	#spells_cast += 1
	#var spell_check = true
	#for i in range(0, spell_record_name_tracker.size()):
		#if spell_record_name_tracker[i] == spell_name:
			#spell_record_tracker[i] = spell_record_tracker[i] + 1
			#spell_check = false
	#if spell_check:
		#spell_record_name_tracker.append(spell_name)
		#spell_record_tracker.append(1)
	pass

func get_highest_spell():
	#for i in range(0, spell_record_name_tracker.size()):
		#if spell_record_tracker[i] > highest_spell_amount:
			#highest_spell_amount = spell_record_tracker[i]
			#highest_spell_name = spell_record_name_tracker[i]
	pass


func _on_chain_ending(max_chain: int) -> void:
	if max_chain > highest_chain:
		highest_chain = max_chain
	pass # Replace with function body.


func _on_block_popped(popped_puyos: Array, chain_value: int) -> void:
	puyos_popped += popped_puyos.size()


func _on_return_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_relic_manager_on_relic_added() -> void:
	#print("relic added")
	relics_picked_up += 1
	pass # Replace with function body.
