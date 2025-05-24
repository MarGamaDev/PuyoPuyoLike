extends CanvasLayer

@onready var equipped_spell_containers : Array[SpellContainer] = []

@onready var spell_container_scene : PackedScene = preload("res://Scenes/spells/spellSystem/spell_container.tscn")

func add_spell(spell_data: SpellData) -> SpellContainer:
	var new_container : SpellContainer = spell_container_scene.instantiate()
	new_container.create_spell_container(spell_data)
	equipped_spell_containers.append(new_container)
	$EquippedSpellsBox.add_child(new_container)
	return new_container

func all_spell_reset():
	for i in equipped_spell_containers:
		i.reset_recipe_visual()

func remove_spell(index : int):
	var to_remove = equipped_spell_containers[index]
	equipped_spell_containers.remove_at(index)
	to_remove.queue_free()
