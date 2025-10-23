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

@export var _entries : Dictionary[String, BlackboardEntry]

func has(key: String):
	return _entries.has(key)

func get_value(key: String):
	return _entries.get(key, null).value

func get_expiration_token(key: String):
	return _entries.get(key, null).expiration_token

func add(key: String, value, expiration_token : Blackboard.ExpirationToken = Blackboard.ExpirationToken.NEVER):
	if typeof(value) == TYPE_STRING:
		value = value.to_snake_case()
	_entries[key] = BlackboardEntry.new(value, expiration_token)

func erase(key: String):
	_entries.erase(key)

func expire(expiration_token : Blackboard.ExpirationToken):
	var keys_to_erase : Array[String] = []
	for key in _entries:
		if _entries[key].expiration_token == expiration_token:
			keys_to_erase.append(key)
	
	for key in keys_to_erase:
		erase(key)

func get_query():
	var query : Dictionary[String, Variant]
	for key in _entries:
		query[key] = _entries[key].value
	return query
