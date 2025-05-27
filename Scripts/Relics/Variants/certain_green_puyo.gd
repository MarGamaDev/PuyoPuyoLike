extends BaseRelic

func initialize():
	super()
	puyo_manager.add_certain_puyo_relic_type(Puyo.PUYO_TYPE.GREEN)
