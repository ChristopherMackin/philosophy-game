extends DebateEventFactory

class_name TestDebateEventFactory

@export var event : Event

func get_event(current_turn : int, played_card : Card) -> Event:
	return event
