@tool
extends TaskAction

class_name WaitTaskAction

func invoke(task : Task, manager : EventManager):
	var time = task.get_input("seconds") if task.get_input("seconds") else 0
	
	await GlobalTimer.wait_for_seconds(time)
	
	on_action_complete.emit(task.get_output(0))
