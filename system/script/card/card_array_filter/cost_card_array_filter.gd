extends CardArrayFilter

class_name CostCardArrayFilter

@export var comparitor: EnumComparitor.Comparitor
@export var cost: int = 0

func filter(card_array: Array[Card], caller: Card, contestant: Contestant, manager: DebateManager) -> Array[Card]:
	return card_array.filter(func(card: Card): return EnumComparitor.evaluate(card.cost, cost, comparitor))
	
