@tool
extends Resource

class_name Blackboard

enum ExpirationToken {
	ON_GAME_RESET = 1 << 0,
	ON_DEBATE_START = 1 << 1,
	ON_TURN_END = 1 << 2,
	ON_TURN_START = 1 << 3,
	ON_ACTION_END = 1 << 4,
	ON_SCENE_ENTER = 1 << 5,
	ON_SCENE_EXIT = 1 << 6,
	ON_VALUE_ACCESSED = 1 << 7,
}

@export var _entries : Array[BlackboardEntry]:
	set(val):
		_entries = Util.auto_populate_resource_array(_entries, val, BlackboardEntry, "New Entry")

func has(key: String):
	return _entries.map(func(x: BlackboardEntry): return x.key).has(key)

func get_value(key: String):
	var index = find_key_index(key)
	if index <= -1: return null
	
	var value = _entries[index].value
	if _entries[index].expiration_flags & ExpirationToken.ON_VALUE_ACCESSED:
		_entries.remove_at(index)
	
	return value

func get_expiration_flags(key: String) -> int:
	var index = find_key_index(key)
	@warning_ignore("incompatible_ternary")
	return _entries[index].expiration_flags if index != -1 else null

func add(key: String, value, expiration_flags: int = 0):
	if !Flag.has_value(key):
		push_warning("% is not part of the flags enumeration and is liable to get lost.")
	
	if typeof(value) == TYPE_STRING:
		value = value.to_snake_case()
	
	var index = find_key_index(key)
	
	if index != -1:
		_entries[index].value = value
		_entries[index].expiration_flags = expiration_flags
	
	else:
		var entry = BlackboardEntry.new()
		entry.key = key
		entry.value = value
		entry.expiration_flags = expiration_flags
		_entries.append(entry)

func erase(key: String):
	var index = find_key_index(key)
	if index == -1: return
	
	_entries.remove_at(index)

func expire(expiration_token : Blackboard.ExpirationToken):
	_entries = _entries.filter(func(x: BlackboardEntry): return !x.expiration_flags & expiration_token)

func get_query():
	var query: Dictionary
	
	if Global.blackboard && self != Global.blackboard:
		query.merge(Global.blackboard.get_query())
	
	for entry in _entries:
		query[entry.key] = entry.value
	
	return query

func find_key_index(key: String):
	return _entries.find_custom(func(x: BlackboardEntry): return x.key == key)

func has_flag(flag: int):
	return has(Flag.name(flag))

func get_flag_value(flag: int):
	return get_value(Flag.name(flag))

func get_flag_expiration_flags(flag: int) -> int:
	return get_expiration_flags(Flag.name(flag))

func add_flag(flag: int, value, expiration_flags: int = 0):
	add(Flag.name(flag), value, expiration_flags)

func erase_flag(flag: int):
	erase(Flag.name(flag))

func find_flag_index(flag: int):
	return find_key_index(Flag.name(flag))
