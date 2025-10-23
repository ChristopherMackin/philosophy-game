extends Resource

class_name BlackboardEntry

@export var value: Variant
@export var expiration_token: Blackboard.ExpirationToken

func _init(value, expiration_token: Blackboard.ExpirationToken = Blackboard.ExpirationToken.NEVER):
	self.value = value
	self.expiration_token = expiration_token
