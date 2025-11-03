extends StatusEffect

class_name CardFilterEffect

@export_enum("Playable", "Holdable", "Selectable") var card_collection := 0

func filter(cards: Array[Card]) -> Array[Card]:
	return cards

func apply(contestant: Contestant):
	super.apply(contestant)
	match card_collection:
		0:
			contestant.playable_card_filter_effects.append(self)
		1:
			contestant.holdable_card_filter_effects.append(self)

func remove(contestant: Contestant):
	super.remove(contestant)
	
	match card_collection:
		0:
			var index = contestant.playable_card_filter_effects.find(self)
			if index == -1: return
			contestant.playable_card_filter_effects.remove_at(index)
		1:
			var index = contestant.holdable_card_filter_effects.find(self)
			if index == -1: return
			contestant.holdable_card_filter_effects.remove_at(index)
