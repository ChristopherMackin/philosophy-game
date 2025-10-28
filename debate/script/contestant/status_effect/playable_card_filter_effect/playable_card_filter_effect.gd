extends StatusEffect

class_name PlayableCardFilterEffect

func filter(cards: Array[Card]) -> Array[Card]:
	return cards

func apply(contestant: Contestant):
	super.apply(contestant)
	contestant.playable_card_filter_condition_effects.append(self)

func remove(contestant: Contestant):
	super.remove(contestant)
	var index = contestant.playable_card_filter_condition_effects.find(self)
	contestant.playable_card_filter_condition_effects.remove_at(index)
