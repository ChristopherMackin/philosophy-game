extends CollectionFilter

class_name SelectionCollectionFilter

@export_enum("Single:1", "Multi:2", "All:3", "First:4") var selection_action := 1
var action: Const.SelectionAction: 
	get(): return selection_action as Const.SelectionAction

func filter(card_array: Array[Card], caller: Card, contestant: Contestant, manager: DebateManager) -> Array[Card]:
	if card_array.size() <= 0: return card_array
	
	var cards : Array[Card]
	
	if action == Const.SelectionAction.ALL:
		cards = card_array
	
	elif card_array.size() == 1 && action == Const.SelectionAction.SINGLE:
		cards = card_array
	
	else:
		var response : SelectionResponse = await contestant.select(SelectionRequest.new(
			card_array,
			action
		))
				
		if action == Const.SelectionAction.SINGLE:
			cards = [response.data]
		elif action == Const.SelectionAction.MULTI:
			cards = response.data
	
	return cards
