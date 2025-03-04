extends CardAction

class_name AddCostModifierToHandCardAction

@export var which_contestant : Constants.Contestant
@export var card_filter : Array[Suit]
@export var cost_modifier : CardCostModifier

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant = player if which_contestant == Constants.Contestant.PLAYER else manager.get_opponent(player)
	
	if contestant.hand.size() <= 0: return
	
	var selectable_cards : Array[Card]
	
	if card_filter.size() > 0:
		selectable_cards.append_array(contestant.hand.filter(func(card): return card_filter.has(card.suit)))
	else:
		selectable_cards = contestant.hand
	
	if selectable_cards.size() <= 0: return
	
	var selected_card : Card = await player.select(
		selectable_cards,
		"%s_add_cost_modifier_to_hand" % Constants.Contestant.keys()[which_contestant]
	)
	
	selected_card.cost_modifiers.append(cost_modifier.duplicate(true))

