@tool
extends ConditionEffect

class_name TokensPlayedEffect

@export var amount: int = 0

@export_group("Suit Filtering")
@export var suits: Array[Suit] = []
@export_enum("Include", "Exclude") var filter_mode := 1

func check() -> bool:
	var history = contestant.manager.blackboard.get_value("turn_token_history")
	if !history: history = []
	var played_suits_history = history.map(func(x): return x.track_suit)
	
	match filter_mode:
		0:
			played_suits_history = played_suits_history.filter(func(x): return suits.has(x))
		1:
			played_suits_history = played_suits_history.filter(func(x): return !suits.has(x))
	
	return played_suits_history.size() < amount
	
