extends Resource

class_name StringRule

@export var string: String:
	set(val):
		string = val
		resource_name = string
@export var rule: Rule
