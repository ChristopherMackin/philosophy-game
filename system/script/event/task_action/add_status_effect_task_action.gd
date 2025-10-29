extends TaskAction

class_name AddStatusEffectTaskAction

func invoke(task : Task, manager : EventManager):
	await manager.add_status_effect(ResourceLoader.load(task.get_input(0)), task.get_input(1))
	on_action_complete.emit(task.get_output(0))
