extends Node
class_name SpellFinder

static var spell_effect_dictionary : Dictionary = {
	"fireball" : "res://Scenes/spells/test_fireball.tscn",
	"sequential_test":"res://Scenes/spells/sequential_test_spell.tscn",
	"hard_test" : "res://Scenes/spells/hard_test.tscn",
	"Resentment" : "res://Scenes/spells/resentment_spell.tscn",
	"Vindication" : "res://Scenes/spells/vindication_spell.tscn",
	"Adamance" : "res://Scenes/spells/adamance_spell.tscn",
	"Hatred" : "res://Scenes/spells/hatred_spell.tscn"
}

static func find_spell(name: String) -> String:
	return spell_effect_dictionary.get(name)
