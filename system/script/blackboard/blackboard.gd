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

@export var _entries : Array[BlackboardEntry]:
	set(val):
		_entries = Util.auto_populate_resource_array(_entries, val, BlackboardEntry, "New Entry")

func has(key: String):
	return _entries.map(func(x: BlackboardEntry): return x.key).has(key)

func get_value(key: String):
	var index = find_key_index(key)
	return _entries[index].value if index != -1 else null

func get_expiration_token(key: String) -> ExpirationToken:
	var index = find_key_index(key)
	@warning_ignore("incompatible_ternary")
	return _entries[index].expiration_token if index != -1 else null

func add(key: String, value, expiration_token : Blackboard.ExpirationToken = Blackboard.ExpirationToken.NEVER):
	if !Flag.has_value(key):
		push_warning("% is not part of the flags enumeration and is liable to get lost.")
	
	if typeof(value) == TYPE_STRING:
		value = value.to_snake_case()
	
	var index = find_key_index(key)
	
	if index != -1:
		_entries[index].value = value
		_entries[index].expiration_token = expiration_token
	
	else:
		var entry = BlackboardEntry.new()
		entry.key = key
		entry.value = value
		entry.expiration_token = expiration_token
		_entries.append(entry)

func erase(key: String):
	var index = find_key_index(key)
	if index == -1: return
	
	_entries.remove_at(index)

func expire(expiration_token : Blackboard.ExpirationToken):
	_entries = _entries.filter(func(x: BlackboardEntry): return x.expiration_token != expiration_token)

func get_query():
	var query: Dictionary
	
	if GlobalBlackboard.blackboard && self != GlobalBlackboard.blackboard:
		query.merge(GlobalBlackboard.blackboard.get_query())
	
	for entry in _entries:
		query[entry.key] = entry.value
	
	return query

func find_key_index(key: String):
	return _entries.find_custom(func(x: BlackboardEntry): return x.key == key)

func has_flag(flag: int):
	return has(Flag.name(flag))

func get_flag_value(flag: int):
	return get_value(Flag.name(flag))

func get_flag_expiration_token(flag: int) -> ExpirationToken:
	return get_expiration_token(Flag.name(flag))

func add_flag(flag: int, value, expiration_token : Blackboard.ExpirationToken = Blackboard.ExpirationToken.NEVER):
	add(Flag.name(flag), value, expiration_token)

func erase_flag(flag: int):
	erase(Flag.name(flag))

func find_flag_index(flag: int):
	return find_key_index(Flag.name(flag))
