@tool
extends Resource

class_name CardCostModifier

@export var priority : int
@export var can_expire : bool = false:
	set(val):
		can_expire = val
		notify_property_list_changed()

@export var turn_lifetime : int = -1
var current_turn : int = 0

func _validate_property(property: Dictionary):
	if property.name == "turn_lifetime" and !can_expire:
		property.usage = PROPERTY_USAGE_NO_EDITOR

func modify_cost(base_cost : int, _manager : DebateManager) -> int:
	return base_cost
