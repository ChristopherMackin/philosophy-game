extends CardAction

class_name AddCostModifierToCardCollectionCardAction

@export var card_collection : CardCollection
@export_enum("Single:1", "Multi:2", "All:3") var selection_action : int
var action: Const.SelectionAction: 
	get(): return selection_action as Const.SelectionAction
@export var cost_modifier : CardCostModifier

func invoke(caller : Card, player : Contestant, manager : DebateManager):
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
		
	
	for card in cards:
		card.cost_modifiers.append(cost_modifier.duplicate(true))
