extends Resource

class_name Character

@export var name: String = "None"

@export_group("Debate Resources")
@export var brain: Brain
@export var deck: Deck
@export var starting_effects: Array[ContestantStatusEffect]

@export_group("Debate Parameters")
@export var energy_level: int = 3
@export var draw_limit: int = 5
@export var hand_limit: int = 8

@export_group("Event Settings")
@export var blackboard: Blackboard
@export var debate_event_factory: EventFactory

func remember(key : String, value, expiration_token : Blackboard.ExpirationToken = Blackboard.ExpirationToken.NEVER):
	var char_key = "%s_%s" % [name.to_snake_case(), key]
	blackboard.add(char_key, value, expiration_token)

func can_recall(key : String):
	var char_key = "%s_%s" % [name.to_snake_case(), key]
	return blackboard.has(char_key)

func recall(key : String):
	var char_key = "%s_%s" % [name.to_snake_case(), key]
	return blackboard.get_value(char_key)
