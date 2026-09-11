extends Node

class_name DebateInitiator

@export var manager: DebateManager
@export var blackboard: Blackboard
@export var debate_settings : DebateSettings
@export var player : Character
@export var computer : Character

func start_debate():
	manager.start_debate(blackboard, player, computer, debate_settings)
	queue_free()
