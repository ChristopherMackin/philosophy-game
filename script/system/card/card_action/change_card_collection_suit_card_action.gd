extends CardAction

class_name ChangeCardCollectionSuitCardAction

@export var card_collection : CardCollection
@export_enum("Single:1", "Multi:2", "All:3") var selection_action := 1
var action: Const.SelectionAction: 
	get(): return selection_action as Const.SelectionAction

@export var suit_options: Array[Suit]
@export_enum("Single:1", "First:4") var suit_selection_action := 4
var suit_action: Const.SelectionAction

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	#Select Card =====================================
	card_collection.init(caller, player, manager)
	var selectable_cards := card_collection.get_card_collection()
	
	if selectable_cards.size() <= 0: return
	
	var cards = []
	
	if action == Const.SelectionAction.ALL:
		cards = selectable_cards
	
	elif selectable_cards.size() == 1 && action == Const.SelectionAction.SINGLE:
		cards = selectable_cards
	
	else:
		var response : SelectionResponse = await player.select(SelectionRequest.new(
			selectable_cards,
			action
		))
		
		cards = response.data
		
		if action == Const.SelectionAction.SINGLE:
			cards = [cards]
		
	#Select Suit =====================================
	var new_suit: Suit
	
	if suit_options.size() == 1 || \
		suit_action == Const.SelectionAction.FIRST:
		new_suit = suit_options[0]
	
	else:
		var response : SelectionResponse = await player.select(SelectionRequest.new(
			suit_options,
			action,
			Const.SelectionType.SUIT
		))
		
		new_suit = response.data
	
	for card in cards:
		card.suit = new_suit
