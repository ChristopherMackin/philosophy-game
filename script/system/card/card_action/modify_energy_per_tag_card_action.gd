extends CardAction

class_name ModifyEnergyPerTagCardAction

@export var which_contestant : Constants.WhichContestant
@export var tag : Constants.Tag
@export var energy_per_tag : float

func invoke(card : Card, player : Contestant, manager : DebateManager):
	var contestant := Constants.GetContestant(player, manager.get_opponent(player), which_contestant)
	
	var tag_count = 0
	for key in manager.suit_track_dictionary:
		tag_count += manager.suit_track_dictionary[key]\
		.filter(func(x): return x.tag == tag).size()
	
	contestant.current_energy += floor(energy_per_tag * tag_count)
	if contestant.current_energy < 0:
		contestant.current_energy = 0
