extends CardAction

class_name Boost

@export var boost_amount : int = 1

func positive_action(manager: DebateManager):
	var suit = manager.current_card.data.suit
	var topic = manager.debate_settings.get_topic(suit)
	var direction = topic.suit_direction(suit)
	
	manager.current_topic_score += 1 * direction

func negative_action(manager: DebateManager):
	var suit = manager.current_card.data.suit
	var topic = manager.debate_settings.get_topic(suit)
	var direction = topic.suit_direction(suit)
	
	manager.current_topic_score -= 1 * direction
