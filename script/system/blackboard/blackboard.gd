@tool
extends Resource

class_name Blackboard

@export var _entries : Dictionary
@export var _expiration_tokens : Dictionary

func has(key: String):
	return _entries.has(key)

func get_value(key: String):
	return _entries.get(key, null)

func get_expiration_token(key: String):
	return _expiration_tokens.get(key, null)

func add(key: String, value, expiration_token : Constants.ExpirationToken = Constants.ExpirationToken.NEVER):
	_entries[key] = value
	_expiration_tokens[key] = expiration_token

func erase(key: String):
	_entries.erase(key)
	_expiration_tokens.erase(key)

func expire(expiration_token : Constants.ExpirationToken):
	var keys_to_erase : Array[String]
	for key in _expiration_tokens:
		if _expiration_tokens[key] == expiration_token:
			keys_to_erase.append(key)
	
	for key in keys_to_erase:
		erase(key)

func get_query():
	return _entries.duplicate()
