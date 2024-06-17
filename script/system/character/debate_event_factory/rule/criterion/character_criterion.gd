extends Criterion

class_name CharacterCriterion

@export var character_name : String
@export var key : DBConst.CharacterSchema

var column:
	get: return DBConst.character_schema_data[key]

func check(query : Dictionary) -> bool:
	var key = "%s.%s" % [character_name, column.key]
	var query_value = query[key] if query.has(key) else null
	
	if !query_value or column.type != typeof(_value):
		return false
	
	return compare(query_value, _value, comparator)
