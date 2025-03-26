extends CardCollection

class_name CallerCard

@export var which_contestant : Const.WhichContestant

func get_card_collection() -> Array[Card]:
	return [caller]
