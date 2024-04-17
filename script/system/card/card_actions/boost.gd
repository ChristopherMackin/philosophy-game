extends CardAction

class_name Boost

@export var boost_amount : int = 1

func positive_action(manager: DebateManager):
	manager.current_topic_score += 1

func negative_action(manager: DebateManager):
	manager.current_topic_score -= 1
