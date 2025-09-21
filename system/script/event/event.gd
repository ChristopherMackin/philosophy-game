extends Resource

class_name Event

enum Frequency {
	ONCE,
	ONCE_PER_DEBATE,
	INFINITE
}

@export var is_major_event := false
@export var await_event := false
@export var frequency : Frequency

@export var start_task : Task = null

@export var tasks : Array[Task] = []

func get_task(index : int):
	if range(tasks.size()).has(index): 
		return tasks[index]
	else:
		return null

func get_expiration_token():
	match frequency:
		Frequency.ONCE:
			return Blackboard.ExpirationToken.NEVER
		Frequency.ONCE_PER_DEBATE:
			return Blackboard.ExpirationToken.ON_DEBATE_START
	
	return null
