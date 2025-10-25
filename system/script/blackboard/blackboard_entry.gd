extends Resource

class_name BlackboardEntry

@export var key: String:
	set(val):
		key = val
		resource_name = key
@export var value: Variant
@export var expiration_token: Blackboard.ExpirationToken
