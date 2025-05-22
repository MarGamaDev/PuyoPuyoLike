extends FlexibleSpell

signal fireball_damage(number :int)
@onready var combat_manager

func setup_processor(data : SpellData):
	super(data)
	combat_manager = get_node("/root/Combat")
	combat_manager.connect("fireball_damage", combat_manager.damage_targeted_enemy)

func connect_to_effect_signals():
	pass

func trigger_spell_effect():
	fireball_damage.emit(10)
