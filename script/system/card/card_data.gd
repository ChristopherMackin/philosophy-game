extends Resource

class_name CardData

@export var token_data : TokenData
@export var base_cost : int
@export var suit : Suit
@export var title : String
@export_multiline var description : String
@export var on_play_card_actions : Array[CardAction]
@export var on_discard_card_actions : Array[CardAction]
@export var on_banish_card_actions : Array[CardAction]
@export var on_turn_start_card_actions : Array[CardAction]
@export var on_turn_end_card_actions : Array[CardAction]
@export var cost_modifiers : Array[CardCostModifier]

func get_cost(manager : DebateManager) -> int:
	var cost = base_cost
	
	cost_modifiers.sort_custom(func(a, b): return a.priority > b.priority)
	
	for modifier in cost_modifiers:
		cost = modifier.modify_cost(cost, manager)
	
	return cost
