class_name EnumMath

enum{
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE,
	POWER,
	MOD,
	REPLACE
}

enum Operation{
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE,
	POWER,
	MOD,
	REPLACE
}

static func evaluate(val1: float, val2: float, operation)-> float:
	match operation:
		ADD:
			return val1 + val2
		SUBTRACT:
			return val1 - val2
		MULTIPLY:
			return val1 * val2
		DIVIDE:
			return val1 / val2
		POWER:
			return pow(val1, val2)
		MOD:
			return fmod(val1, val2)
		REPLACE:
			return val2
	
	push_error("ERROR: MATH OPERATION NOT FOUND")
	return val1
