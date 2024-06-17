extends Criterion

class_name DebateCriterion

@export var key : DBConst.DebateSchema
var column:
	get: return DBConst.debate_schema_data[key]

func check(query : Dictionary) -> bool:
	var query_value = query[column.key] if query.has(column.key) else null
	
	if !query_value or column.type != typeof(_value):
		return false
	
	return compare(query_value, _value, comparator)
