extends Resource
class_name SpellData

enum RECIPE_TYPE {FLEXIBLE, SEQUENTIAL, HARD_SEQUENTIAL}

var type_text = {
	RECIPE_TYPE.FLEXIBLE : "Forgiving",
	RECIPE_TYPE.SEQUENTIAL : "Suggesting",
	RECIPE_TYPE.HARD_SEQUENTIAL : "Rigid"
}	

@export var spell_name : String
@export var spell_description: String
@export var flavor_text : String
@export var recipe_type : RECIPE_TYPE
@export var recipe_contents : Array[Puyo.PUYO_TYPE] #ordered correctly
@export var spell_path : String = ""

#func get_spell_path() -> String:
	#return spell_effect_dictionary[spell_name]
