extends Event

class_name WaitEvent

@export var wait_time : float = 0

func invoke(manager : EventManager):
	await manager.get_tree().create_timer(wait_time).timeout
	return next_list[0] if next_list.size() > 0 else null
