class_name ApplyCardStatusEffect
extends StatusEffect

@export_enum("Hand", "Hold") var card_collection := 0
@export var card_status_effect: CardStatusEffect

func _add_status_effect(card: Card):
	card_status_effect.apply(card)

func apply(contestant: Contestant):
	super.apply(contestant)
	match card_collection:
		0:
			for card in contestant.hand.get_cards(): _add_status_effect(card)
			contestant.hand.on_added.add_listener(_add_status_effect, 1)
		1:
			for card in contestant.held_card.get_cards(): _add_status_effect(card)
			contestant.held_card.on_added.add_listener(_add_status_effect)

func remove(contestant: Contestant):
	super.remove(contestant)
	
	match card_collection:
		0: 
			contestant.hand.on_added.remove_listener(_add_status_effect)
		1:
			contestant.held_card.on_added.remove_listener(_add_status_effect)
