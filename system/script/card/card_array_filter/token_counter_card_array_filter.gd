extends CardArrayFilter

class_name TokenCounterCardArrayFilter

@export var comparitor: EnumComparitor.Comparitor
@export var amount: int = 0

func filter(card_array: Array[Card], caller: Card, contestant: Contestant, manager: DebateManager) -> Array[Card]:	
	return card_array.filter(func(card: Card): return EnumComparitor.evaluate(card.token_counter, amount, comparitor))
	
