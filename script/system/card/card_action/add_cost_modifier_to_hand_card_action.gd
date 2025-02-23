extends CardAction

class_name AddCostModifierToHandCardAction

@export var suit_filter : Array[Suit]
@export var cost_modifier : CardCostModifier

func invoke(card : Card, player : Contestant, manager : DebateManager):
	if player.hand.size() <= 0: return
	
	var selectable_cards : Array[Card]
	
	if suit_filter.size() > 0:
		selectable_cards.append_array(player.hand.filter(func(card): return suit_filter.has(card.suit)))
	else:
		selectable_cards = player.hand
	
	if selectable_cards.size() <= 0: return
	
	var selected_card : Card = await player.select(
		selectable_cards,
		"add_cost_modifier_to_hand",
		true
	)
	
	selected_card.cost_modifiers.append(cost_modifier.duplicate(true))

