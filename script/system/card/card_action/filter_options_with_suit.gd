@tool
extends CardAction

class_name FilterOptionsWithSuitCardAction

@export var suits_parameter_type := Const.ActionParameterType.VALUE:
	set(val):
		suits_parameter_type = val
		notify_property_list_changed()

@export var suits : Array[Suit]
@export var suits_key : String = "suits"

func get_suits_array(manager: DebateManager):
		match suits_parameter_type:
			Const.ActionParameterType.VALUE:
				return suits
			Const.ActionParameterType.KEY:
				return manager.blackboard.get_value(suits_key)

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var options = manager.blackboard.get_value("action.options")
	var selection_type := manager.blackboard.get_value("action.type") as Const.SelectionType
	var suits = get_suits_array(manager)
	
	if options == null || options.size() <= 0: return true
	
	match selection_type:
		Const.SelectionType.CARD:
			options = options.filter(func(x): return suits.has(x.suit))
		Const.SelectionType.TOKEN:
			pass
		Const.SelectionType.SUIT:
			pass
	
	manager.blackboard.add("action.options", options, Const.ExpirationToken.ON_ACTION_END)
	
	return true
