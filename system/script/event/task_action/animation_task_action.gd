@tool
extends TaskAction

class_name AnimationTaskAction

func invoke(task : Task, manager : EventManager):
	await manager.play_animation(task.get_input("trigger"), task.get_input("actor"), task.get_input("overwrite"), task.get_input("await"))
	on_action_complete.emit(task.get_output(0))

func cancel(task : Task, manager : EventManager):
	on_action_complete.emit(-1)
	manager.cancel_animation(task.get_input("actor"))
