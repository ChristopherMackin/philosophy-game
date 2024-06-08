extends Resource

class_name Rule

@export_multiline var criteria : String

func check(query : Dictionary) -> bool:
	if criteria == "":
		return true
	
	var criterion_array = criteria.split("\n")
	for c in criterion_array:
		var has_passed
		var parts = c.split(" ")
		if parts.size() == 1:
			var key = parts[0]
			if key[0] == "!":
				key.erase(0)
				has_passed = !query.get(key)
			else:
				has_passed = query.get(key)
		elif parts.size() == 3:
			var query_value = query[parts[0]]
			var comparator = parts[1]
			var value = str_to_var(parts[2])
			
			if typeof(query_value) != typeof(value):
				return false
			
			match comparator:
				"=", "==":
					has_passed = query_value == value
				"!=":
					has_passed = query_value != value
				">":
					has_passed = query_value > value
				">=":
					has_passed = query_value >= value
				"<":
					has_passed = query_value < value
				"<=":
					has_passed = query_value <= value
				_:
					has_passed = false
		else:
			has_passed = false
		
		if !has_passed:
			return false
	
	return true
