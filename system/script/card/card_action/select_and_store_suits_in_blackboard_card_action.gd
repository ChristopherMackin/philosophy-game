extends CardAction

class_name SelectAndStoreSuitsInBlackboardCardAction

@export var key: String = "suits"
@export var suit_options: Array[Suit]
@export_enum("Single:1", "First:-1") var suit_selection_action := -1
var suit_action: Const.SelectionAction:
	get(): return suit_selection_action as Const.SelectionAction


func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	#Select Suit =====================================
	var stored_suits: Array[Suit]
	
	if suit_options.size() == 1 || \
		suit_selection_action == -1:
		stored_suits = [suit_options[0]]
	
	else:
		var response : SelectionResponse = await player.select(SelectionRequest.new(
			suit_options,
			suit_action,
			Const.SelectionType.SUIT
		))
		stored_suits = [response.data]
	
	manager.blackboard.add("action_%s" % key, stored_suits, Blackboard.ExpirationToken.ON_ACTION_END)
	
	return true
