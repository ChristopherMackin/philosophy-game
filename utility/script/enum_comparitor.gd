class_name EnumComparitor

enum{
	EQUALS,
	NOT_EQUALS,
	LESS_THAN,
	LESS_THAN_EQUALS,
	GREATER_THAN,
	GREATER_THAN_EQUALS,
}

enum Comparitor{
	EQUALS,
	NOT_EQUALS,
	LESS_THAN,
	LESS_THAN_EQUALS,
	GREATER_THAN,
	GREATER_THAN_EQUALS,
}

static func evaluate(val1, val2, comparitor: Comparitor) -> bool:
	match comparitor:
		EQUALS: return val1 == val2
		NOT_EQUALS: return val1 != val2
		LESS_THAN: return val1 < val2
		LESS_THAN_EQUALS: return val1 <= val2
		GREATER_THAN: return val1 > val2
		GREATER_THAN_EQUALS: return val1 >= val2
	
	return false
