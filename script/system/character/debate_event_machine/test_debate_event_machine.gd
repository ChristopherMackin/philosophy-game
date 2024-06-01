extends DebateEventMachine

class_name TestDebateEventMachine

@export var event_tree : EventTree

func get_event_tree(current_turn : int, played_card : Card) -> EventTree:
	return event_tree
