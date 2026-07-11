@tool
extends TaskAction

class_name DialogueTaskAction

func invoke(task : Task, manager : EventManager):	
	canceled = false
	
	await Util.await_any([
		func(): await manager.display_dialogue(task.get_input(0), task.get_input(1), task.get_input(2), task.get_input(3)),
		func(): await on_action_canceled
	])
		
	if canceled:
		return
	
	on_action_complete.emit(task.get_output(0))

func cancel(task: Task, manager: EventManager):
	super.cancel(task, manager)
	manager.cancel_dialogue(task.get_input(1))
