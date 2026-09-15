@tool
extends CardAction

class_name AlterCardCollectionTokensCardAction

@export var card_collection: CardCollectionContainer

@export_enum("Discard", "Play", "Replace") var alteration_mode: int:
	set(val):
		alteration_mode = val
		notify_property_list_changed()
@export_enum("Suit", "Blackboard Suits", "Caller Suit") var suit_selection_mode : int = 0:
	set(val):
		suit_selection_mode = val
		notify_property_list_changed()

@export var suit: Suit
@export var key: String = "action_suits"
@export var token: TokenData

func _validate_property(property: Dictionary):
		if _hide_suit(property): property.usage = PROPERTY_USAGE_NO_EDITOR
		if _hide_key(property): property.usage = PROPERTY_USAGE_NO_EDITOR
		if _hide_selection_mode(property): property.usage = PROPERTY_USAGE_NO_EDITOR
		if _hide_token(property): property.usage = PROPERTY_USAGE_NO_EDITOR

func _hide_suit(property) -> bool:
	return property.name == "suit" and (suit_selection_mode != 0 or alteration_mode != 1)

func _hide_key(property) -> bool:
	return property.name == "key" and (suit_selection_mode != 1 or alteration_mode != 1)

func _hide_selection_mode(property) -> bool:
	return property.name == "suit_selection_mode" and alteration_mode != 1

func _hide_token(property) -> bool:
	return property.name == "token" and alteration_mode != 2

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	match alteration_mode:
		0:
			return await _discard_tokens(caller, player, manager)
		1:
			return await _play_tokens(caller, player, manager)
		2:
			return true
		_:
			return false
	

func _play_tokens(caller : Card, player : Contestant, manager : DebateManager):
	card_collection.init(caller, player, manager)
	var cards = await card_collection.get_collection_cards()
	
	match suit_selection_mode:
		0:
			for card in cards:
				if !card.has_token: continue
				manager.play_token(card.pop_token(), suit, player)
		1:
			var suit = manager.blackboard.get_value(key)[0]
			for card in cards:
				if !card.has_token: continue
				manager.play_token(card.pop_token(), suit, player)
		2:
			for card in cards:
				if !card.has_token: continue
				manager.play_token(card.pop_token(), card.suit, player)
	
	return true

func _discard_tokens(caller : Card, player : Contestant, manager : DebateManager):
	card_collection.init(caller, player, manager)
	var cards = await card_collection.get_collection_cards()
	for card in cards:
		card.pop_token()
	return true

func _replace_tokens(caller : Card, player : Contestant, manager : DebateManager):
	card_collection.init(caller, player, manager)
	var cards = await card_collection.get_collection_cards()
	
	for card in cards:
		if card.has_token:
			card.replace_token(Token.new(token))
	
	return true
