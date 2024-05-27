extends Event

class_name StartEvent

func invoke(event_manager : EventManager) -> Event:
	return next_list[0] if next_list.size() > 0 else null
