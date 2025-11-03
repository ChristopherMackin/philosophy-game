extends TaskAction

class_name RemoveStatusEffectTaskAction

func skip(task: Task, manager : EventManager):
	await invoke(task, manager)

func invoke(task : Task, manager : EventManager):
	await manager.remove_status_effect(ResourceLoader.load(task.get_input(0)), task.get_input(1))
	on_action_complete.emit(task.get_output(0))
