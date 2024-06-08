extends Resource

class_name Character

@export var name : String = "None"
@export var deck : Deck
@export var brain : Brain
@export var hand_limit : int = 5
@export var energy_level : int = 2
@export var debate_event_factory : EventFactory
@export var memory : DictionaryVariable
