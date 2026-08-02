extends Node

class_name EventSubscriber

@export var manager : EventManager:
	set(val):
		if manager:
			manager.unsubscribe(self)
		
		manager = val
		
		if manager:
			manager.subscribe(self)

signal _on_dialogue_canceled
var dialogue_canceled: bool = false

func _notification(what):
	if (what == NOTIFICATION_PREDELETE):
		if manager:
			manager.unsubscribe(self)

func _start_event(_event: Event):
	pass

func _end_event(_event: Event):
	pass

func display_dialogue(_dp: DialoguePayload):
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
