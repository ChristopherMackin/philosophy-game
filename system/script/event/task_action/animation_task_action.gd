extends TaskAction

class_name AnimationTaskAction

func invoke(task : Task, manager : EventManager):
	await manager.play_animation(task.get_input(0), task.get_input(1), task.get_input(2), task.get_input(3))
	on_action_complete.emit(task.get_output(0))

func cancel(task : Task, manager : EventManager):
	on_action_complete.emit(-1)
	manager.cancel_animation(task.get_input(1))
