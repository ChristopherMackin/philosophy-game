extends CardAction

class_name SelectAndStoreSuitsInBlackboardCardAction

@export var key: String = "suits"
@export var suit_options: Array[Suit]
@export_enum("Single:1", "Multi:2", "All:3", "First:4") var suit_selection_action := 1
var suit_action: Const.SelectionAction:
	get(): return suit_selection_action as Const.SelectionAction

func invoke(caller : Card, player : Contestant, manager : DebateManager):
	#Select Suit =====================================
	var suits: Array[Suit]
	
	if suit_options.size() == 1 && suit_action == Const.SelectionAction.SINGLE:
		suits = suit_options
	elif suit_action == Const.SelectionAction.FIRST:
		suits = [suit_options[0]]
	
	else:
		var response : SelectionResponse = await player.select(SelectionRequest.new(
			suit_options,
			suit_action,
			Const.SelectionType.SUIT
		))
		
		if suit_action == Const.SelectionAction.SINGLE:
			suits = [response.data]
		elif suit_action == Const.SelectionAction.MULTI:
			suits = response.data
	
	manager.blackboard.add("action.%s" % key, suits, Const.ExpirationToken.ON_ACTION_END)
