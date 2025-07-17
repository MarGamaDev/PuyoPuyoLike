@tool

extends RichTextEffect
class_name RichTextColor

var bbcode := "puyo"

func _process_custom_fx(char_fx) -> bool:
	var blood_color = Color("FD5433")
	var yellow_bile_color = Color("F6E019")
	var black_bile_color = Color("5DAAF7")
	var phlegm_color = Color("A2D42F")
	var toxin_color = Color("EDAAF5")
	var text_type = char_fx.env.get("type")
	match text_type:
		"blood":
			char_fx.color = blood_color
		"phlegm":
			char_fx.color = phlegm_color
		"bbile":
			char_fx.color = black_bile_color
		"ybile":
			char_fx.color = yellow_bile_color
		"toxin":
			char_fx.color = toxin_color
	return true
