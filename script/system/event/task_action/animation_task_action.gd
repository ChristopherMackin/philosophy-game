extends TaskAction

class_name AnimationTaskAction

func invoke(event : Task, manager : EventManager) -> int:
	var animation_name = event.get_input(0)
	var actor_name = event.get_input(1)
	var await_animation = event.get_input(2)
	
	await manager.play_animation(animation_name, actor_name, await_animation)
	return event.get_output(0)
