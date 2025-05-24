extends CanvasLayer

signal remove_spell(index : int)

func handle_spell_selection(spells : Array[SpellNode]):
	$ColorRect/VBoxContainer/Button.text = spells[0].spell_data.spell_name
	$ColorRect/VBoxContainer/Button2.text = spells[1].spell_data.spell_name
	$ColorRect/VBoxContainer/Button3.text = spells[2].spell_data.spell_name


func spell_selected(index : int):
	remove_spell.emit(index)


func _on_button_pressed() -> void:
	spell_selected(0)
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	spell_selected(1)
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	spell_selected(2)
	pass # Replace with function body.
