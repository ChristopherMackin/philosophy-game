extends CardAction

class_name AddCostModifierToHandCardAction

@export var which_contestant : Constants.WhichContestant
@export var card_filter : Array[Suit]
@export var cost_modifier : CardCostModifier

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant := Constants.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	if contestant.hand.size() <= 0: return
	
	var selectable_cards : Array[Card]
	
	if card_filter.size() > 0:
		selectable_cards.append_array(contestant.hand.filter(func(card): return card_filter.has(card.suit)))
	else:
		selectable_cards = contestant.hand
	
	if selectable_cards.size() <= 0: return
	
	var response : SelectionResponse = await player.select(SelectionRequest.new(
		selectable_cards,
		"%s_add_cost_modifier_to_hand" % Constants.WhichContestant.keys()[which_contestant]
	))
	
	response.data.cost_modifiers.append(cost_modifier.duplicate(true))

