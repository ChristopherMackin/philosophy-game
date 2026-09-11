@tool
extends TaskAction

class_name WaitTaskAction

func invoke(task : Task, manager : EventManager):
	var time = task.get_input("seconds") if task.get_input("seconds") else 0
	
	await manager.start_timer(time)
	
	on_action_complete.emit(task.get_output(0))

func cancel(_task : Task, manager : EventManager):
	manager.cancel_timer()
	
	super.cancel(_task, manager)
