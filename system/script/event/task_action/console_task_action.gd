extends TaskAction

class_name ConsoleTaskAction

func skip(task: Task, manager : EventManager):
	invoke(task, manager)

func invoke(task : Task, manager : EventManager):
	print(task.get_input(0))
	on_action_complete.emit(task.get_output(0))
