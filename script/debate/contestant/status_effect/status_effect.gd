extends Resource

class_name StatusEffect

@export var priority : int
@export var can_expire : bool = false:
	set(val):
		can_expire = val
		notify_property_list_changed()

@export var turn_lifetime : int = -1

func _validate_property(property: Dictionary):
	if property.name == "turn_lifetime" and !can_expire:
		property.usage = PROPERTY_USAGE_NO_EDITOR

func apply(contestant: Contestant):
	contestant.status_effects.append(self)

func remove(contestant: Contestant):
	var index = contestant.status_effects.find(self)
	contestant.status_effects.remove_at(index)
