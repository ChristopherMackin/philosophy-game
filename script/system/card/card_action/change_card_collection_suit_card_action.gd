extends CardAction

class_name ChangeCardCollectionSuitCardAction

@export var card_collection : CardCollection

@export var suit_options: Array[Suit]
@export_enum("Single:1", "First:4") var suit_selection_action := 4
var suit_action: Const.SelectionAction:
	get(): return suit_selection_action as Const.SelectionAction


func invoke(caller : Card, player : Contestant, manager : DebateManager):
	card_collection.init(caller, player, manager)
	var cards = await card_collection.get_card_collection()
		
	#Select Suit =====================================
	var new_suit: Suit
	
	if suit_options.size() == 1 || \
		suit_action == Const.SelectionAction.FIRST:
		new_suit = suit_options[0]
	
	else:
		var response : SelectionResponse = await player.select(SelectionRequest.new(
			suit_options,
			suit_action,
			Const.SelectionType.SUIT
		))
		
		new_suit = response.data
	
	for card in cards:
		card.suit = new_suit
