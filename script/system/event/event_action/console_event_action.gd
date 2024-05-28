extends EventAction

class_name ConsoleEventAction

func invoke(event : Event, manager : EventManager) -> Event:
	print(event.get_input(0))
	return event.get_output(0)
