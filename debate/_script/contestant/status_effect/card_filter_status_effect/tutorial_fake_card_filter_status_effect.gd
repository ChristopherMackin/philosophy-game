extends CardFilterStatusEffect

class_name TutorialFakeCardFilterStatusEffect

func filter(_cards: Array[Card]) -> Array[Card]:
	return [Card.new(CardBase.new(), DebateManager.new())]
