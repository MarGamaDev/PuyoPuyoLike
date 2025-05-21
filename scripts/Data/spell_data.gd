extends Resource
class_name SpellData

enum RECIPE_TYPE {FLEXIBLE, SEQUENTIAL, HARD_SEQUENTIAL}

@export var spell_name : String
@export var recipe_type : RECIPE_TYPE
@export var recipe_contents : Array[Puyo.PUYO_TYPE] #ordered correctly
