extends TaskAction

class_name DialogueTaskAction

func invoke(task : Task, manager : EventManager):
	await manager.display_dialogue(task.get_input(0), task.get_input(1))
	on_action_complete.emit(task.get_output(0))

func cancel(task: Task, manager: EventManager):
	on_action_complete.emit(-1)
	manager.cancel_dialogue(task.get_input(1))
