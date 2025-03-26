extends CardAction

class_name DiscardCardFromCardCollectionCardAction

@export var card_collection_factory : CardCollection
@export var which_contestant : Const.WhichContestant
@export_enum("Single:1", "Multi:2", "ALL:3") var selection_action : int
var action: Const.SelectionAction: 
	get(): return selection_action as Const.SelectionAction
	
func invoke(caller : Card, player : Contestant, manager : DebateManager):
	card_collection_factory.init(caller, player, manager)
	
	var contestant := Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	var selectable_cards := card_collection_factory.get_card_collection()
	
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
		
	
	for card in cards:
		contestant.discard_card(card)
		card_collection_factory.remove_card_from_collection(card)
