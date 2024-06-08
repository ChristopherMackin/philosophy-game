extends TaskAction

class_name ConsoleTaskAction

func invoke(task : Task, manager : EventManager) -> int:
	print(task.get_input(0))
	return task.get_output(0)
