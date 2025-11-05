extends CollectionFilter

class_name SelectionCollectionFilter

@export var visible_to_player := true
@export var amount := 1
@export var min_amount := 1

func filter(card_array: Array[Card], caller: Card, contestant: Contestant, manager: DebateManager) -> Array[Card]:
	if card_array.size() <= 0: return card_array
	
	var cards : Array[Card]
	
	for filter: CardFilterEffect in contestant.selectable_card_filter_effects.values:
		card_array = filter.filter(card_array)
	
	var response : SelectionResponse = await contestant.select(SelectionRequest.new(
		card_array,
		Const.SelectionAction.SELECT,
		Const.SelectionType.CARD,
		visible_to_player,
		amount,
		min_amount
	))
	
	cards.assign(response.data)
	
	return cards
