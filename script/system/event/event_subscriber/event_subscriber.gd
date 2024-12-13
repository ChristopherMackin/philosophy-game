extends Node

class_name EventSubscriber

@export var manager : EventManager

func _ready():
	manager.subscribe(self)

func display_dialogue(line : String, actor : String, await_input : bool, seconds_before_close : float):
	pass

func cancel_dialogue(actor : String):
	pass

func play_animation(name : String, actor : String, await_animation: bool):
	pass

func cancel_animation(actor : String):
	pass
