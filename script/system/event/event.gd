extends Resource

class_name Event

@export var start_task : Task = null

@export var tasks : Array[Task] = []

func get_task(index : int):
	if range(tasks.size()).has(index): 
		return tasks[index]
	else:
		return null
