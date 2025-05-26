extends Control
class_name SpellContainer

var recipe_puyo_active_sprite_dictionary = {
	Puyo.PUYO_TYPE.JUNK : "res://Placeholder Art/puyo_junk.png",
	Puyo.PUYO_TYPE.RED : "res://Art/spell elements/puyo-redIcon_new.png",
	Puyo.PUYO_TYPE.GREEN : "res://Art/spell elements/puyo-greenIcon.png",
	Puyo.PUYO_TYPE.BLUE : "res://Art/spell elements/puyo-blackIcon.png",
	Puyo.PUYO_TYPE.YELLOW : "res://Art/spell elements/puyo-yellowIcon.png",
	#Puyo.PUYO_TYPE.RAINBOW : "res://Placeholder Art/puyo_rainbow.png"
}

var recipe_puyo_inactive_sprite_dictionary = {
	Puyo.PUYO_TYPE.JUNK : "res://Placeholder Art/puyo_junk.png",
	Puyo.PUYO_TYPE.RED : "res://Art/spell elements/puyo-redIcon.png",
	Puyo.PUYO_TYPE.GREEN : "res://Art/spell elements/puyo-greenIcon-deactive.png",
	Puyo.PUYO_TYPE.BLUE : "res://Art/spell elements/puyo-blackIcon_deactive.png",
	Puyo.PUYO_TYPE.YELLOW : "res://Art/spell elements/puyo-yellowIcon-deactive.png",
	#Puyo.PUYO_TYPE.RAINBOW : "res://Placeholder Art/puyo_rainbow.png"
}

var recipe_type_sprite_dictionary = {
	SpellData.RECIPE_TYPE.FLEXIBLE : "res://Art/spell elements/puyo-plusSign.png",
	SpellData.RECIPE_TYPE.SEQUENTIAL : "res://Art/spell elements/puyo-arrowSign.png",
	SpellData.RECIPE_TYPE.HARD_SEQUENTIAL : "res://Art/spell elements/puyo-equalSign.png"
} 

var spell_data : SpellData
var recipe_length : int = 3
var recipe_contents : Array[Puyo.PUYO_TYPE] = []
var recipe_rects : Array[TextureRect] = []
var default_sprites : Array[Texture2D] = []

var reward_flag : bool = false

var sprite_scaling = 1
var connection_scaling = 1

func _ready():
	var viewport_height = get_viewport_rect().size.y
	custom_minimum_size.y = viewport_height / 9

func create_spell_container(new_spell_data : SpellData, reward_check := false) -> void:
	reward_flag = reward_check
	spell_data = new_spell_data
	recipe_contents = spell_data.recipe_contents
	recipe_length = recipe_contents.size()
	fill_recipe_container()
	$SpellGraphic/SpellName.text = spell_data.spell_name

func fill_recipe_container() -> void:
	if recipe_length <= 1:
		return
	
	if recipe_length == 3:
		connection_scaling = 0.75
	elif recipe_length > 3:
		connection_scaling = 0.6
		sprite_scaling = 0.8
	
	var connections_needed : int = recipe_length - 1
	var puyo_component_flag : bool = true
	var connection_texture : Texture2D = load(recipe_type_sprite_dictionary[spell_data.recipe_type])
	
	for i in range(0, connections_needed + recipe_length):
		var new_component : TextureRect = TextureRect.new()
		new_component.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		new_component.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		new_component.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#new_component.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		if puyo_component_flag:
			if reward_flag:
				new_component.texture = load(recipe_puyo_active_sprite_dictionary[recipe_contents[(i / 2)]])
			else:
				new_component.texture = load(recipe_puyo_inactive_sprite_dictionary[recipe_contents[(i / 2)]])
			puyo_component_flag = false
		else:
			new_component.texture = connection_texture
			puyo_component_flag = true
		$RecipeContainer.add_child(new_component)
		recipe_rects.append(new_component)
		default_sprites.append(new_component.texture)

func reset_recipe_visual():
	for i in range(0, recipe_rects.size()):
		recipe_rects[i].texture = default_sprites[i]

func progress_spell_visual(component_to_activate: int):
	#print(component_to_activate)
	recipe_rects[component_to_activate * 2].texture = load(recipe_puyo_active_sprite_dictionary[recipe_contents[component_to_activate]])

func on_new_player_turn_taken():
	reset_recipe_visual()
	#$SpellProcessor.reset_spell()

func on_spell_complete() -> void:
	reset_recipe_visual()
	$TestParticleEffect.restart()

func get_marker() -> Control:
	return $EffectMarker
