extends EventAction

class_name DialogueEventAction

func invoke(event : Event, manager : EventManager) -> int:
	await manager.display_dialogue(event.get_input(0))
	return event.get_output(0)
