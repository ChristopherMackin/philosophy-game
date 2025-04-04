extends CardAction

class_name ModifyEnergyPerCardCardAction

@export var which_contestant: Const.WhichContestant
@export var collection : CardCollectionContainer
@export var energy_per_card : float

func invoke(caller : Card, player : Contestant, manager : DebateManager) -> bool:
	var contestant = Const.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	collection.init(caller, player, manager)
	var card_count = (await collection.get_collection_cards()).size()
	
	contestant.current_energy += floor(energy_per_card * card_count)
	if contestant.current_energy < 0:
		contestant.current_energy = 0
	
	return true
