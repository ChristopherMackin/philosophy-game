@abstract
class_name CardStatusEffect
extends Resource

@export_group("Status Effect Info")
@export var name: String
@export var description: String

@export_group("Lifetime")
@export var priority : int
@export var can_expire : bool = false:
	set(val):
		can_expire = val
		notify_property_list_changed()
@export var turn_lifetime : int = -1

var card: Card

func _validate_property(property: Dictionary):
	if property.name == "turn_lifetime" and !can_expire:
		property.usage = PROPERTY_USAGE_NO_EDITOR

func apply(card: Card):
	card.status_effects.add(self)
	self.card = card

func remove(card: Card):
	var index = card.status_effects.find(self)
	card.status_effects.remove_at(index)
	self.card = null

func get_progress_display() -> String:
	return ""
