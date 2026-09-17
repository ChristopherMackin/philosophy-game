class_name Flag
extends Object

enum {
	CONCEPT,
	PLAYER,
	COMPUTER,
	CURRENT_TURN,
	CURRENT_ROUND,
	ACTIVE_CONTESTANT,
	CARD_HISTORY,
	TURN_CARD_HISTORY,
	TOKEN_HISTORY,
	TURN_TOKEN_HISTORY,
	CURRENT_SUIT,
	LINES_CLEARED,
	DEBATES_FINISHED,
	SPAWN_INDEX,
	CARDS_PLAYED_THIS_TURN,
	TOKENS_PLAYED_THIS_TURN,
	
	#Action Flags
	ACTION_ADDED_CARD_BASE,
	ACTION_VIEWED_CARDS,
	ACTION_MOVED_CARDS_FROM,
	ACTION_DUPLICATE_CARDS_FROM,
	ACTION_MOVED_CARDS_TO,
	ACTION_DUPLICATE_CARDS_TO,
	ACTION_DISCARDED_CARDS,
	ACTION_BANISHED_CARDS,
	ACTION_ADDED_CARD_STATUS_EFFECT
	
}

static func name(value: int) -> String:
	var current_script: GDScript = load("res://system/script/flag.gd")
	var constant_map: Dictionary = current_script.get_script_constant_map()
	
	for constant_name in constant_map:
		if constant_map[constant_name] == value:
			return constant_name
			
	return "Unknown"

static func has_value(value: String) -> bool:
	var current_script: GDScript = load("res://system/script/flag.gd")
	var constant_map: Dictionary = current_script.get_script_constant_map()
		
	return constant_map.find_key(value) != -1
