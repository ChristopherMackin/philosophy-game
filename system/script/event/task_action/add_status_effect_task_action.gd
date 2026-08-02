@tool
extends TaskAction

class_name AddStatusEffectTaskAction

func skip(task: Task, manager : EventManager):
	await invoke(task, manager)
	
func invoke(task : Task, manager : EventManager):
	await manager.add_status_effect(ResourceLoader.load(task.get_input("status_effect")), task.get_input("player"))
	on_action_complete.emit(task.get_output(0))
