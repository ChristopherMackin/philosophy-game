extends TaskAction

class_name WaitTaskAction

func invoke(task : Task, manager : EventManager) -> int:
	var time = task.get_input(0) if task.get_input(0) else 0
	
	await GlobalTimer.wait_for_seconds(time)
	var next = task.get_output(0)
	return next
