extends Node

class_name EventSubscriber

@export var manager : EventManager

func _ready():
	manager.subscribe(self)

func display_dialogue(text : String):
	pass
