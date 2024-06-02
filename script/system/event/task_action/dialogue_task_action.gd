extends TaskAction

class_name DialogueTaskAction

func invoke(event : Task, manager : EventManager) -> int:
	await manager.display_dialogue(event.get_input(0))
	return event.get_output(0)
