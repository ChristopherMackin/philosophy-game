@tool
class_name FlagValueRule
extends Rule

@export var flag: Flag.Flag
@export var comparitor: EnumComparitor.Comparitor
@export var value: Variant

func check(_query : Dictionary) -> bool:
	if !Global.blackboard.has_flag(flag): return false
	
	return EnumComparitor.evaluate(Global.blackboard.get_flag_value(flag), value, comparitor)
