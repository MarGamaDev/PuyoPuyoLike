extends TextureButton

class_name MapNode

@export var location_sprites : Array[Texture2D]

enum LOCATION_TYPES {ENEMY, BOSS, SHOP}
var location_type : LOCATION_TYPES = LOCATION_TYPES.ENEMY

func create(type : LOCATION_TYPES):
	texture_normal = location_sprites[type]
	location_type = type
