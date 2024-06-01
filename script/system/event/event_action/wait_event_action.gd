extends EventAction

class_name WaitEventAction

func invoke(event : Event, manager : EventManager) -> int:
	var time = event.get_input(0) if event.get_input(0) else 0
	
	await GlobalTimer.wait_for_seconds(time)
	var next = event.get_output(0)
	return next
