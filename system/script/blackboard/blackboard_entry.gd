@tool
extends Resource

class_name BlackboardEntry

@export var key: String:
	set(val):
		key = val
		resource_name = key
@export var value: Variant
@export var expiration_flags: int = 0

# This function builds the inspector interface dynamically
func _validate_property(property: Dictionary) -> void:
	if property.name == "expiration_flags":
		property.hint = PROPERTY_HINT_FLAGS
		property.hint_string = ",".join(Blackboard.ExpirationToken.keys()) # Automatically maps keys to checkboxes
