extends CardFilterEffect

class_name TutorialFakeCardFilterEffect

func filter(_cards: Array[Card]) -> Array[Card]:
	return [Card.new(CardBase.new(), DebateManager.new())]
