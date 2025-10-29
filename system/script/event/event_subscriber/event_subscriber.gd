extends Node

class_name EventSubscriber

@export var manager : EventManager

func _ready():
	manager.subscribe(self)

func _start_event(_event: Event):
	pass

func _end_event(_event: Event):
	pass

func display_dialogue(_line : String, _actor : String, _await_input : bool, _seconds_before_close : float):
	pass

func cancel_dialogue(_actor : String):
	pass

func play_animation(_animation : String, _actor : String, _overwrite_animation: bool, _await_animation: bool):
	pass

func cancel_animation(_actor : String):
	pass

func add_status_effect(_effect: StatusEffect, _which_player: Const.Player):
	pass

func remove_status_effect(_effect: StatusEffect, _which_player: Const.Player):
	pass
