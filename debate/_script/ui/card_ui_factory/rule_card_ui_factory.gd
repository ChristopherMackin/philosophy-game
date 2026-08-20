extends CardUiFactory

class_name RuleCardUiFactory

@export var rule: Rule
@export var bb: Blackboard
@export var card_ui_factory: CardUiFactory

func get_card_ui(card: Card) -> PackedScene:
	if !card || !rule || !rule.check(bb.get_query()): return
	
	return card_ui_factory.get_card_ui(card)
