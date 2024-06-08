extends TaskAction

class_name AnimationTaskAction

func invoke(task : Task, manager : EventManager) -> int:
	var animation_name = task.get_input(0)
	var actor_name = task.get_input(1)
	var await_animation = task.get_input(2)
	
	await manager.play_animation(animation_name, actor_name, await_animation)
	return task.get_output(0)
