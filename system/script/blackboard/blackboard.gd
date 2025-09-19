@tool
extends Resource

class_name Blackboard

enum ExpirationToken {
	NEVER,
	ON_GAME_RESET,
	ON_DEBATE_START,
	ON_TURN_END,
	ON_TURN_START,
	ON_ACTION_END,
	ON_SCENE_ENTER,
	ON_SCENE_EXIT,
}

@export var _entries : Dictionary[String, Variant]
@export var _expiration_tokens : Dictionary[String, ExpirationToken]

func has(key: String):
	return _entries.has(key)

func get_value(key: String):
	return _entries.get(key, null)

func get_expiration_token(key: String):
	return _expiration_tokens.get(key, null)

func add(key: String, value, expiration_token : Blackboard.ExpirationToken = Blackboard.ExpirationToken.NEVER):
	if typeof(value) == TYPE_STRING:
		value = value.to_snake_case()
	_entries[key] = value
	_expiration_tokens[key] = expiration_token

func erase(key: String):
	_entries.erase(key)
	_expiration_tokens.erase(key)

func expire(expiration_token : Blackboard.ExpirationToken):
	var keys_to_erase : Array[String] = []
	for key in _expiration_tokens:
		if _expiration_tokens[key] == expiration_token:
			keys_to_erase.append(key)
	
	for key in keys_to_erase:
		erase(key)

func get_query():
	return _entries.duplicate()
