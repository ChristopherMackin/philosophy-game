extends Resource

class_name CardBase

@export var suit : Suit

@export var title : String
@export var base_cost : int
@export_multiline var description : String

@export var token_data : TokenData

@export_group("Action & Modifier")
@export var on_play_card_actions : Array[CardAction]
@export var on_discard_card_actions : Array[CardAction]
@export var on_banish_card_actions : Array[CardAction]
@export var on_turn_start_card_actions : Array[CardAction]
@export var on_turn_end_card_actions : Array[CardAction]
@export var cost_modifiers : Array[CardCostModifier]
