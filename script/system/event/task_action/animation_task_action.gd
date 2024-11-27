extends TaskAction

class_name AnimationTaskAction

func invoke(task : Task, manager : EventManager):
	var animation_name = task.get_input(0)
	var actor_name = task.get_input(1)
	var await_animation = task.get_input(2)
	
	await manager.play_animation(animation_name, actor_name, await_animation)
	on_action_complete.emit(task.get_output(0))

func cancel(task : Task, manager : EventManager):
	var actor_name = task.get_input(1)
	
	manager.cancel_animation(actor_name)
