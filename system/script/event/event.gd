extends Resource

class_name Event

enum Frequency {
	ONCE,
	ONCE_PER_SCENE,
	INFINITE
}

@export var skip:= false

@export var can_interupt := false
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
		Frequency.ONCE_PER_SCENE:
			return Blackboard.ExpirationToken.ON_DEBATE_START
	
	return null
