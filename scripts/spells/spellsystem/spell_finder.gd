extends Node
class_name SpellFinder

static var spell_effect_dictionary : Dictionary = {
	"fireball" : "res://Scenes/spells/test_fireball.tscn"
}

static func find_spell(name: String) -> String:
	return spell_effect_dictionary.get(name)
