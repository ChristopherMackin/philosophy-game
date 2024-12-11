extends Resource

class_name Rule

@export var concept : String
@export var criteria : Array[Criterion]

func check(query : Dictionary) -> bool:
	if query["concept"] != concept:
		return false
	
	for c in criteria:
		if !c.check(query):
			return false
	
	return true
