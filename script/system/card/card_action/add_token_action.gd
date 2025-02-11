extends CardAction

class_name DuplicateCardAction

@export var amount : int

func invoke(card : Card, player : Contestant, manager : DebateManager):
	for i in amount:
		await player.play_card_cost_override(card, 0, false)
