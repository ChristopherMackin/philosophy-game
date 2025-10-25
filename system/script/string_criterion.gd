extends Resource

class_name StringCriterion

@export var string: String:
	set(val):
		string = val
		resource_name = string
@export var criterion: Criterion
