extends BaseRelic

##whenever you successfully cast a spell, trigger the effect of a random puyo
##x times [variable] times, where x is chain length, with chain 1

signal shaman_stone_attack(attack : PlayerAttack)

@export var pop_amount : int = 2

func initialize():
	super()
	spell_manager.on_spell_cast.connect(shaman_stone_trigger)
	shaman_stone_attack.connect(combat_manager.process_player_attack)

func shaman_stone_trigger(spell_length : int):
	print("shaman_stone_trigger %s times" % spell_length)
	for i in range(0, spell_length):
		var type : Puyo.PUYO_TYPE
		match (randi_range(0,3)):
			0:
				type = Puyo.PUYO_TYPE.BLUE
			1:
				type = Puyo.PUYO_TYPE.RED
			2:
				type = Puyo.PUYO_TYPE.GREEN
			3:
				type = Puyo.PUYO_TYPE.YELLOW
		shaman_stone_attack.emit(PlayerAttack.create_manually(pop_amount,type,1))
		if type == Puyo.PUYO_TYPE.RED or type == Puyo.PUYO_TYPE.GREEN:
			update_enemy_damage_visuals.emit()
	
