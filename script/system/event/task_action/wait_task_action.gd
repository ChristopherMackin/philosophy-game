extends TaskAction

class_name WaitTaskAction

signal cancel_timer

func invoke(task : Task, manager : EventManager) -> int:
	var time = task.get_input(0) if task.get_input(0) else 0
	
	var func_array : Array[Callable] = [
		func() : await GlobalTimer.wait_for_seconds(time),
		func() : await cancel_timer
	]
	
	await Util.await_any(func_array)
	
	var next = task.get_output(0)
	return next

func cancel(task : Task, manager : EventManager):
	cancel_timer.emit()
