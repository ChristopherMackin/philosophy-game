extends TaskAction

class_name DialogueTaskAction

func invoke(task : Task, manager : EventManager) -> int:
	await manager.display_dialogue(task.get_input(0), task.get_input(1))
	return task.get_output(0)

func cancel(task: Task, manager: EventManager):
	manager.cancel_dialogue(task.get_input(1))
