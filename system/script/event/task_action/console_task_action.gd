extends TaskAction

class_name ConsoleTaskAction

func invoke(task : Task, manager : EventManager):
	print(task.get_input(0))
	on_action_complete.emit(task.get_output(0))
