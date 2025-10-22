extends Resource

class_name Rule

@export var criteria : Array[Criterion]

func check(query : Dictionary) -> bool:
	for c in criteria:
		if !c.check(query):
			return false
	
	return true
