extends CanvasLayer

@onready var equipped_spells : Array[SpellContainer] = []

@onready var spell_container_scene : PackedScene = preload("res://Scenes/RewardScreen/spell_container.tscn")

func add_spell(spell_data: SpellData):
	if equipped_spells.size() >= 3:
		print("too many spells!")
		push_error("todo, add selection window for equipping more spells")
	else:
		var new_container : SpellContainer = spell_container_scene.instantiate()
		new_container.create_spell_container(spell_data)
		equipped_spells.append(new_container)
		$EquippedSpellsBox.add_child(new_container)
