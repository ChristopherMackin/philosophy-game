extends Resource

class_name CardData

@export var token_data : TokenData
@export var base_cost : int
@export var suit : Suit
@export var title : String
@export_multiline var description : String
@export var on_make_selection_action : Array[CardAction]
@export var on_discard_card_action : Array[CardAction]
@export var on_banish_card_action : Array[CardAction]
@export var cost_modifier : CardCostModifier = CardCostModifier.new()

func get_cost(manager : DebateManager) -> int:
	return cost_modifier.modify_cost(base_cost, manager)
