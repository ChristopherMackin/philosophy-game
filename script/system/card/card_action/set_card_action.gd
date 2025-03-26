extends CardAction

class_name SetCardAction

@export var selection_target_index : int = 0
@export var selection_source_index : int = 0

@export var target_property_name : String
@export var source_property_name : String

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var selection_target = manager.blackboard.get_value("action.selection_%s" % selection_target_index)
	var selection_source = manager.blackboard.get_value("action.selection_%s" % selection_source_index)
	
	for s in selection_target:
		
