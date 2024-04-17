extends Resource

class_name CardAction

@export var positive_description : String
@export var positive_icon : Texture2D

func positive_action(manager: DebateManager):
	pass

@export var negative_description : String
@export var negative_icon : Texture2D

func negative_action(manager: DebateManager):
	pass
