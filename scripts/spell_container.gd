extends Control

class_name SpellContainer

var recipe_puyo_sprite_dictionary = {
	Puyo.PUYO_TYPE.JUNK : "res://Placeholder Art/puyo_junk.png",
	Puyo.PUYO_TYPE.RED : "res://Placeholder Art/puyo_red.png",
	Puyo.PUYO_TYPE.GREEN : "res://Placeholder Art/puyo_green.png",
	Puyo.PUYO_TYPE.BLUE : "res://Placeholder Art/puyo_blue.png",
	Puyo.PUYO_TYPE.YELLOW : "res://Placeholder Art/puyo_yellow.png",
	Puyo.PUYO_TYPE.RAINBOW : "res://Placeholder Art/puyo_rainbow.png"
}

var recipe_type_sprite_dictionary = {
	SpellData.RECIPE_TYPE.FLEXIBLE : "res://Placeholder Art/flexible_connection.png",
	SpellData.RECIPE_TYPE.SEQUENTIAL : "res://Placeholder Art/sequential_connection.png",
	SpellData.RECIPE_TYPE.HARD_SEQUENTIAL : "res://Placeholder Art/hard_sequential_connection.png"
} 

var spell_data : SpellData
var spell_name : String = "spell name"
var recipe_length : int = 3
var recipe_type : SpellData.RECIPE_TYPE = SpellData.RECIPE_TYPE.FLEXIBLE
var recipe_contents : Array[Puyo.PUYO_TYPE] = []

@export var test_spell : SpellData

func _ready():
	create_spell_container(test_spell)


func create_spell_container(new_spell_data : SpellData) -> void:
	spell_data = new_spell_data
	spell_name = spell_data.spell_name
	recipe_type = spell_data.recipe_type
	recipe_contents = spell_data.recipe_contents
	recipe_length = recipe_contents.size()
	fill_recipe_container()

func fill_recipe_container() -> void:
	if recipe_length <= 1:
		return
	
	var connections_needed : int = recipe_length - 1
	var puyo_component_flag : bool = true
	var connection_texture : Texture2D = load(recipe_type_sprite_dictionary[recipe_type])
	
	for i in range(0, connections_needed + recipe_length):
		var new_component : TextureRect = TextureRect.new()
		new_component.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		new_component.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		new_component.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		if puyo_component_flag:
			new_component.texture = load(recipe_puyo_sprite_dictionary[recipe_contents[(i / 2)]])
			puyo_component_flag = false
		else:
			new_component.texture = connection_texture
			puyo_component_flag = true
		$RecipeContainer.add_child(new_component)
