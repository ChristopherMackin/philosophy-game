extends TaskAction

class_name ConsoleTaskAction

func invoke(event : Task, manager : EventManager) -> int:
	print(event.get_input(0))
	return event.get_output(0)
