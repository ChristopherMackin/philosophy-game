extends Resource

class_name ConditionEffect

@export var name: String
@export_multiline var description: String

func check(manager : DebateManager) -> bool:
	return false
