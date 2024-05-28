extends EventAction

class_name WaitEventAction

func invoke(event : Event, manager : EventManager) -> Event:
	await manager.get_tree().create_timer(event.get_input(0) or 0).timeout
	return event.get_output(0)
