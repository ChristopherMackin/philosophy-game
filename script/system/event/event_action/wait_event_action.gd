extends EventAction

class_name WaitEventAction

func invoke(event : Event, manager : EventManager) -> Event:
	var time = event.get_input(0) if event.get_input(0) else 0
	
	await manager.get_tree().create_timer(time).timeout
	return event.get_output(0)
